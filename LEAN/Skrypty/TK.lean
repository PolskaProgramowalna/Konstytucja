import Konstytucja.TK.Test.Testy
import Lean

open Konstytucja.TK.Test

structure Options where
  command : String := ""
  repo : Option System.FilePath := none
  registry : Option System.FilePath := none
  output : Option System.FilePath := none
  draft : Bool := false
  assumptions : Assumptions := {}
  limit : Option Nat := none
  maxModule : Nat := 3
  deriving Inhabited

def usage := "Test TK w Lean (bez Pythona)\n\nUżycie: ./tk_test.sh POLECENIE [opcje]\nPolecenia: waliduj, przygotuj, lean, testy, oblicz\n\nOpcje:\n  --roboczo            wymagane dla obliczeń przy niezatwierdzonych parametrach\n  --bez-ad NAZWA        wyłącz jawne założenie danych (AD1–AD7)\n  --wyjście PLIK        ścieżka raportu lub wygenerowanego pliku Lean\n  --rejestr PLIK        alternatywny CSV\n  --repo KATALOG        katalog repozytorium (zwykle ustalany automatycznie)\n  --limit-m1 N          jawna, niepełna próba techniczna\n  --moduł M1|M2|M3      zakres obliczenia (domyślnie M3)\n"

def parseOptions (args : List String) : Except String Options := do
  let mut o : Options := {}
  let mut rest := args
  for _ in [:args.length] do
    match rest with
    | [] => break
    | "--roboczo"::xs => o := {o with draft := true}; rest := xs
    | "--repo"::x::xs => o := {o with repo := some x}; rest := xs
    | "--rejestr"::x::xs => o := {o with registry := some x}; rest := xs
    | "--wyjście"::x::xs | "--wyjscie"::x::xs | "--output"::x::xs => o := {o with output := some x}; rest := xs
    | "--bez-ad"::x::xs => o := {o with assumptions := (← disable o.assumptions x)}; rest := xs
    | "--limit-m1"::x::xs =>
      let some n := x.toNat? | throw "--limit-m1 wymaga liczby"
      unless n > 0 && n ≤ 192 do throw "--limit-m1: zakres 1–192"
      o := {o with limit := some n}; rest := xs
    | "--moduł"::x::xs =>
      unless #["M1","M2","M3"].contains x do throw "nieznany moduł"
      o := {o with maxModule := if x == "M1" then 1 else if x == "M2" then 2 else 3}; rest := xs
    | x::xs =>
      if o.command.isEmpty && #["waliduj","przygotuj","lean","testy","oblicz"].contains x then
        o := {o with command := x}; rest := xs
      else throw s!"Nieznany argument lub brak wartości: {x}"
  if o.command.isEmpty then throw usage
  return o

def findRepo (explicit : Option System.FilePath) : IO System.FilePath := do
  if let some p := explicit then return p
  for start in #[← IO.currentDir,← IO.appDir] do
    let mut p := start
    for _ in [:8] do
      if ← (p / "LEAN/dane/tk_rejestr.csv").pathExists then return p
      p := p.parent.getD p
  throw (IO.userError "Nie znaleziono repozytorium; podaj --repo")
def sha256 (path : System.FilePath) : IO String := do
  let p ← IO.Process.output {cmd := "sha256sum",args := #[path.toString]}
  unless p.exitCode == 0 do throw (IO.userError p.stderr)
  return (p.stdout.splitOn " ")[0]!
def today : IO String := do
  let p ← IO.Process.output {cmd := "date",args := #["+%F"]}
  unless p.exitCode == 0 do throw (IO.userError p.stderr)
  return trim p.stdout
def save (p : System.FilePath) (text : String) : IO Unit := do
  if let some dir := p.parent then IO.FS.createDirAll dir
  IO.FS.writeFile p text
  IO.println s!"zapisano {p}"

def errorText : Except String α → String | .error e => e | .ok _ => ""

def main (args : List String) : IO UInt32 := do
  if args.contains "--help" || args.contains "-h" then IO.println usage; return 0
  let .ok o := parseOptions args | IO.eprintln (errorText (parseOptions args)); return 2
  try
    let repo ← findRepo o.repo
    let csvPath := o.registry.getD (repo / "LEAN/dane/tk_rejestr.csv")
    let text ← IO.FS.readFile csvPath
    let .ok parsed := parseRegistry text | IO.eprintln (errorText (parseRegistry text)); return 1
    let registry := validate parsed
    for e in registry.errors do IO.eprintln s!"BŁĄD {e}"
    for e in registry.warnings do IO.eprintln s!"OSTRZEŻENIE {e}"
    if o.command == "waliduj" then
      IO.println s!"wiersze: {registry.rows.size}, błędy: {registry.errors.size}, ostrzeżenia: {registry.warnings.size}"
      return if registry.errors.isEmpty then 0 else 1
    unless registry.errors.isEmpty do return 1
    if o.command == "testy" then
      let cases := testCases registry
      let mut failed := 0
      for (name,ok) in cases do
        if !ok then failed := failed+1; IO.eprintln s!"FAIL: {name}"
      let expected := leanData registry (← sha256 csvPath)
      let actual ← IO.FS.readFile (repo / "LEAN/Konstytucja/TK/CiagloscDane.lean")
      if actual != expected then
        failed := failed+1; IO.eprintln "FAIL: CiagloscDane.lean nieaktualne; uruchom ./tk_test.sh lean"
      IO.println s!"Testy Lean: {cases.size+1}, błędy: {failed}"
      return if failed == 0 then 0 else 1
    if o.command == "lean" then
      save (o.output.getD (repo / "LEAN/Konstytucja/TK/CiagloscDane.lean")) (leanData registry (← sha256 csvPath))
      return 0
    if o.command == "przygotuj" then
      save (o.output.getD (repo / "TK/Przygotowanie_testu.md")) (preparation registry o.assumptions (← today))
      return 0
    unless o.draft do
      IO.eprintln "Parametry Z1–Z14, R-PUB i AD1–AD7 nie są zatwierdzone. Obliczenie wymaga --roboczo (plan, pkt 10)."
      return 2
    let result := run registry o.assumptions o.limit o.maxModule
    save (o.output.getD (repo / "TK/Wynik_testu_ciaglosci.md")) (report registry result (← today))
    IO.println s!"warianty: M1={result.counts[0]!}, M2={result.counts[1]!}, M3={result.counts[2]!}"
    return 0
  catch e => IO.eprintln e.toString; return 1
