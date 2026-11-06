import Lean

/-! # Kontrola projektu (zasada Z6)

Uruchomienie z katalogu LEAN/, po `lake build`:
`lake env lean --run Skrypty/KontrolaProjektu.lean`

Lista modułów pochodzi z dysku, a nie z importów, więc obejmuje też pliki niezaimportowane.
Plik `.lean` spoza biblioteki nie ma skompilowanej wersji, dlatego kończy kontrolę błędem.
Każda deklaracja może zależeć tylko od trzech standardowych aksjomatów Lean.
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

def main : IO UInt32 := do
  initSearchPath (← findSysroot)
  let pliki ← plikiProjektu
  let moduły := pliki.map nazwaModułu
  let env ← importModules (moduły.map ({ module := · })) {} (trustLevel := 0)
  let mut liczba := 0
  let mut błędy : Array String := #[]
  for (nazwa, _) in env.constants.map₁.toList do
    let some i := env.getModuleIdxFor? nazwa | continue
    unless moduły.contains env.header.moduleNames[i.toNat]! do continue
    liczba := liczba + 1
    let złe ← złeAksjomaty env nazwa
    unless złe.isEmpty do
      błędy := błędy.push s!"{nazwa}: {złe}"
  if !błędy.isEmpty then
    IO.eprintln s!"Niedozwolone aksjomaty:\n{"\n".intercalate błędy.toList}"
    return 1
  IO.println s!"Moduły: {moduły.size}, deklaracje: {liczba}, bez niedozwolonych aksjomatów"
  return 0
