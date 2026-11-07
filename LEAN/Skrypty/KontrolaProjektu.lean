import Lean

/-! # Kontrola projektu (zasada Z6)

Uruchomienie z katalogu LEAN/, po `lake build`:
`lake env lean --run Skrypty/KontrolaProjektu.lean`

Lista modułów pochodzi z dysku, a nie z importów, więc obejmuje też pliki niezaimportowane.
Plik `.lean` spoza biblioteki nie ma skompilowanej wersji, dlatego kończy kontrolę błędem.
Każda deklaracja może zależeć tylko od trzech standardowych aksjomatów Lean. Skrypt sprawdza
też, czy nazwy z `dane/rejestr.csv` istnieją w skompilowanym środowisku, a nie tylko w tekście.
-/

open Lean

def pominięte : List String := [".lake", "Skrypty"]

/-- Nazwa modułu dla pliku względem katalogu projektu. -/
def nazwaModułu (plik : System.FilePath) : Name :=
  (plik.withExtension "").components.foldl (fun n s => n.str s) .anonymous

def plikiProjektu : IO (Array System.FilePath) := do
  let wszystkie ← System.FilePath.walkDir "." fun k =>
    pure !(pominięte.contains (k.fileName.getD ""))
  return wszystkie.filter (·.extension == some "lean") |>.map fun p =>
    ⟨(p.toString.dropPrefix "./").toString⟩

def złeAksjomaty (env : Environment) (nazwa : Name) : IO (Array Name) := do
  let dozwolone := [``propext, ``Classical.choice, ``Quot.sound]
  let (aksjomaty, _) ← (collectAxioms nazwa : CoreM _).toIO
    { fileName := "kontrola", fileMap := default } { env }
  return aksjomaty.filter (!dozwolone.contains ·)

/-- Nazwy definicji i twierdzeń z rejestru. -/
def nazwyRejestru : IO (Array String) := do
  let wiersze ← IO.FS.lines "dane/rejestr.csv"
  let mut wynik : Array String := #[]
  for w in wiersze[1:] do
    let pola := w.splitOn ","
    if pola.length ≥ 7 then
      for pole in [pola[5]!, pola[6]!] do
        for n in pole.splitOn ";" do
          if !n.isEmpty then wynik := wynik.push n
  return wynik

/-- Wszystkie sufiksy nazwy, np. `a.b.c`, `b.c` i `c`. -/
def sufiksy (n : Name) : List String :=
  let części := (n.components.map (·.toString (escape := false)))
  (List.range części.length).map fun i => ".".intercalate (części.drop i)

def main : IO UInt32 := do
  initSearchPath (← findSysroot)
  let pliki ← plikiProjektu
  let moduły := pliki.map nazwaModułu
  let env ← importModules (moduły.map ({ module := · })) {} (trustLevel := 0)
  let mut liczba := 0
  let mut błędy : Array String := #[]
  let mut znane : Std.HashSet String := {}
  for (nazwa, _) in env.constants.map₁.toList do
    let some i := env.getModuleIdxFor? nazwa | continue
    unless moduły.contains env.header.moduleNames[i.toNat]! do continue
    liczba := liczba + 1
    for s in sufiksy nazwa do
      znane := znane.insert s
    let złe ← złeAksjomaty env nazwa
    unless złe.isEmpty do
      błędy := błędy.push s!"{nazwa}: {złe}"
  if !błędy.isEmpty then
    IO.eprintln s!"Niedozwolone aksjomaty:\n{"\n".intercalate błędy.toList}"
    return 1
  let brakujące := (← nazwyRejestru).filter (!znane.contains ·)
  if !brakujące.isEmpty then
    IO.eprintln s!"Nazwy z rejestru nie istnieją w środowisku Lean:\n{"\n".intercalate brakujące.toList}"
    return 1
  IO.println s!"Moduły: {moduły.size}, deklaracje: {liczba}, bez niedozwolonych aksjomatów"
  return 0
