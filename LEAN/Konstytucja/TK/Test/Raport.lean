import Konstytucja.TK.Test.Przebieg

namespace Konstytucja.TK.Test

def table (header : Array String) (rows : Array (Array String)) : String :=
  let line := fun xs => "| " ++ join " | " (xs.map fun s => s.replace "|" "/" |>.replace "\n" " ") ++ " |\n"
  line header ++ line (header.map (fun _ => "---")) ++ String.join (rows.toList.map line)
def completeness (r : Registry) : Array (String × Nat × Nat) := Id.run do
  let es := r.types #["E1"]; let os := sorted (unique (es.map (·.person)))
  let zs := r.types #["E8"]; let ds := r.types #["ORZ"]
  let count := fun {α : Type} (xs : Array α) (p : α → Bool) => ((xs.filter p).size,xs.size)
  let pairs := #[
    ("D1 wakat zamierzony", count es (·.vacancy != "?")),
    ("D1 początek kadencji w uchwale", count es (fun w => !(w.a "poczatek").isEmpty)),
    ("D1 wynik głosowania", count es (fun w => !(w.a "za").isEmpty || !(w.a "lista").isEmpty)),
    ("D3 ślubowanie lub odmowa", count os (fun o => !(r.forPerson o #["E2","E3"]).isEmpty)),
    ("D5 ZO: lista obecnych", count zs (fun w => (w.a "obecni").contains '+')),
    ("D6 skład orzeczenia", count ds (fun w => w.a "sklad" "?" != "?")),
    ("D6 wynik głosowania", count ds (fun w => w.a "wynik" "?" != "?")),
    ("D10 dopuszczenie udokumentowane", count os (fun o => !(r.forPerson o #["E4"]).isEmpty))]
  return pairs.map fun (name,(a,b)) => (name,a,b)
def assumptionDescriptions : Array String := #[
  "zdarzenia E6 spoza rejestru nie występują",
  "osoby bez E3 i bez ślubowania innej formy złożyły ślubowanie wobec Prezydenta w późniejszym z dni wyboru i początku kadencji",
  "osoby bez E3 i E4 dopuszczono w dniu ślubowania",
  "brak daty początku kadencji: faktyczny początek liczony od wyboru",
  "osoby spoza sporu zakończyły funkcję z faktycznym końcem kadencji, jeżeli brak późniejszych E5",
  "postanowienia E7 są kompletne w oknie badania",
  "osoby z E3 bez E4 nie wykonywały funkcji przed pierwszym udokumentowanym E5"]
def assumptionsTable (ad : Assumptions) : String := table #["id","treść","włączone"]
  ((List.range 7).toArray.map fun n => #[s!"AD{n+1}",assumptionDescriptions[n]!,if ad.flags[n]! then "tak" else "nie"])
def coverage : Array String := #[
  "W1: wiedza prawnicza — ocenne, poza obliczeniem",
  "W1: zakaz ponownego wyboru — rejestr nie obejmuje wyborów sprzed 2006 r.",
  "W2: odrębne głosowanie nad uchwałą ZO — D11 nie wczytane",
  "W5: art. 131 ust. 1 — poza zakresem",
  "W6a: ostateczność orzeczeń — brak kompletnego modelu kwestionowania",
  "Z11a/Z12b: akty D11 nie wczytane; wyniki NIEUSTALONE",
  "Z11b: kworum składów NIEPOKRYTE",
  "F1 (osiągalność), F3, F5, F7, F8: otwarte; metoda liczników jest przybliżeniem przedziałowym"]
def observations (r : Registry) (ad : Assumptions) : String := Id.run do
  let as := alternatives r
  if as.isEmpty then return "Brak spójnych alternatyw danych.\n"
  let i := #[("z1","a"),("z2","a"),("z4","a"),("z7","c"),("z12","a")]
  let s := calculate r i as[0]! ad
  let mut out := ""
  for w in s.choices do
    if !w.root && !(w.row.a "poczatek").isEmpty then
      if let some d := w.free then
        if d.known && iso d.lo != w.row.a "poczatek" then
          out := out ++ s!"- {w.person}: początek w uchwale {w.row.a "poczatek"}, wakat według modelu {iso d.lo}. Konwencja dat wymaga decyzji recenzenta.\n"
  out := out ++ s!"- Stan wyjściowy według roboczych AD: F = {(counters s tStart)[1]!.text}. Nie jest to ustalenie o TK. Rejestr zawiera lukę dotyczącą odejścia L. Bagińskiej.\n"
  let missing := (r.types #["E1"]).filter (·.vacancy == "?")
  out := out ++ s!"- Wakat nieustalony: {missing.size} wyborów ({join ", " (missing.map (·.person))}).\n"
  out := out ++ "- Do uzupełnienia: ślubowania, protokoły ZO, orzeczenia i akty D11, w tym zmiana ustawy Dz.U. 2026 poz. 26.\n"
  return out
def preparation (r : Registry) (ad : Assumptions) (date : String) : String :=
  let counts := #[(variants 1).size,(variants 2).size,(variants 2).size*extensionCount,1]
  "# Przygotowanie testu ciągłości TK\n\n" ++
  s!"Wygenerowano: {date}, przez `tk_test przygotuj` (Lean). **Bez wyników testu historycznego.**\n\n" ++
  s!"## Walidacja\n\nWiersze: {r.rows.size}; wybory: {(r.types #["E1"]).size}; błędy: {r.errors.size}; ostrzeżenia: {r.warnings.size}.\n\n" ++
  "## Kompletność danych\n\n" ++ table #["kategoria","ustalone","wszystkie"]
    ((completeness r).map fun (name,a,b) => #[name,toString a,toString b]) ++
  "\n## Założenia danych (robocze)\n\n" ++ assumptionsTable ad ++
  "\n## Warianty\n\n" ++ table #["moduł","nominalnie","po utożsamieniu 4.6"]
    ((#[1,2,3,4]).map fun m => #[s!"M{m}",toString (totalVariants m),toString counts[m-1]!]) ++
  s!"\nAlternatywy A: {(alternatives r).size}; M3 × A: {counts[2]!*(alternatives r).size}. Liczby przed uzupełnieniami niepewności.\n\n" ++
  "## Ustalenia robocze o danych\n\n" ++ observations r ad ++
  "\n## Pokrycie i ograniczenia\n\n" ++ join "\n" (coverage.map ("- "++·)) ++
  "\n\n## Dalsze prace\n\nZatwierdzenie parametrów Z1–Z14, R-PUB, AD1–AD7 i konwencji dat przez prawnika. Kontrole formalne otwarte pozostają otwarte po migracji. Obliczenia: `./oblicz_tk.sh`.\n"

def dependence (a : Aggregate) (exact : Array String := #[]) : String :=
  if a.counts.size == 1 then "jednolity" else
  let ps := if exact.isEmpty then a.influences else sorted exact
  if ps.isEmpty then "łącznie kilka parametrów (miara marginalna)" else join ", " ps
def report (r : Registry) (w : Result) (date : String) : String := Id.run do
  let mut out := "# Wynik testu ciągłości TK (roboczy)\n\n> **WYNIK ROBOCZY.** Parametry Z1–Z14, R-PUB i AD1–AD7 nie są zatwierdzone. Wynik warunkowy, bez mocy prawnej i bez werdyktu o TK.\n\n"
  out := out ++ s!"Wygenerowano: {date}, silnik Lean. M1: {w.counts[0]!}, M2: {w.counts[1]!}, M3: {w.counts[2]!}. Alternatywy A: {w.alternatives.size}.\n"
  if w.partialRun then out := out ++ "\n> **PRÓBA TECHNICZNA: NIEPEŁNY PRZEGLĄD.** Nie jest analizą odporności pełnego zbioru wariantów.\n"
  out := out ++ "\n## Założenia danych\n\n" ++ assumptionsTable w.assumptions
  out := out ++ "\n## Tabela A. Przyporządkowania wakatów\n\n"
  for ai in [:w.alternatives.size] do
    out := out ++ s!"- A{ai}: " ++ join ", " (w.alternatives[ai]!.filterMap fun (o,v) => if v.isEmpty then none else some s!"{o}→{v}") ++ "\n"
  out := out ++ "\n## Tabela B. Liczniki (obwiednia wariantów)\n\n"
  let mut rows : Array (Array String) := #[]; let mut previous : Option (Array Bounds) := none
  for (d,bs) in w.envelope.toArray.qsort (fun a b => a.1 < b.1) do
    if previous == some bs then continue
    previous := some bs; rows := rows.push (#[iso d] ++ bs.map (·.text))
  out := out ++ table #["od dnia","T","F","B","W","Z","U"] rows
  out := out ++ "\n## Tabela C. Oceny wymogów\n\n"
  rows := #[]
  let aggregates := w.aggregates.toArray.qsort (fun a b => a.1 < b.1)
  for (k,a) in aggregates do
    if !#["E1:","ocena:","kierownictwo:"].any (fun p => k.startsWith p) then continue
    let tr := w.trace[k]?.getD {}
    rows := rows.push #[k,countText a.counts,dependence a (w.exactInfluence[k]?.getD #[]),tr.norms,join "; " tr.sources,join ", " (sorted tr.intervals)]
  out := out ++ table #["wymóg/czynność","wynik: warianty","zależy od","W","D","przedziały"] rows
  out := out ++ "\n## Tabela D. Orzeczenia\n\n"
  rows := #[]
  for (k,a) in aggregates do
    if k.startsWith "orzeczenie:" then
      let name := (k.drop 11).toString
      let sources := (r.types #["ORZ"]).filter (fun x => x.a "sprawa" == name) |>.flatMap (·.sources)
      rows := rows.push #[name,countText a.counts,dependence a,"W1 W2 W3 W6d W11",join "; " (unique sources)]
  out := out ++ table #["sprawa","skutek łączny: warianty","zależy od","W","D"] rows
  out := out ++ "\n## Tabela E. Publikacja (R-PUB)\n\n"
  rows := w.publications.map fun p => #[p.row.a "sprawa",iso p.row.day,
    if p.result == notApplicable then "-" else if p.published.isSome then toString p.elapsed else s!">= {p.elapsed} (do końca okna)",
    (if p.result == notApplicable then "-" else join ", " (#[14,30,60].map fun n => s!"{n}: {if p.elapsed > n then "tak" else "nie"}")),p.result,p.cause,
    join "; " p.events,join "; " p.notes]
  out := out ++ table #["sprawa","data","dni","przekroczenia N1","W6b","przyczyna","zdarzenia","uwagi"] rows
  out := out ++ "\n## Tabela F. Odporność\n\n"
  out := out ++ s!"Wyniki jednolite: {(w.aggregates.valuesArray.filter (·.counts.size == 1)).size} z {w.aggregates.size}. Jednolite NIEUSTALONE nie jest rozstrzygnięciem. Dla M1 test zmiany jednego parametru; M2/M3: miara marginalna. Zakres ograniczony do zbadanych wariantów; F7 pozostaje otwarte.\n"
  out := out ++ "\n## Tabela G. Pokrycie\n\n" ++ join "\n" (coverage.map ("- "++·)) ++ "\n"
  for n in [:3] do
    out := out ++ s!"\n## K{n+1}\n\n"
    rows := #[]; let mut prev := ""
    for (d,cs) in w.daily.toArray.qsort (fun a b => a.1 < b.1) do
      let v := join ", " (sorted cs[n]!)
      if v != prev then rows := rows.push #[iso d,v]; prev := v
    out := out ++ table #["od dnia","wartości w wariantach"] rows
  out := out ++ "\n## K4 — miara roczna\n\n"
  rows := #[]
  for y in years do
    for x in thresholds do
      let key := s!"{y}:{x}"
      if let some cs := w.annual[key]? then
        let complete := (r.types #["D6_ROK"]).any (fun row => row.a "rok" == toString y)
        rows := rows.push #[toString y,s!"{x}%",countText cs,
          (if complete then "D6_ROK" else "brak liczby orzeczeń roku") ++ (if y == 2026 then "; rok niepełny" else if y == 2015 then "; od 2015-10-01" else "")]
  out := out ++ table #["rok","X","K4: warianty","kompletność"] rows
  return out

/-- Reprezentacja F2 zachowuje oryginalne identyfikatory w osobnym sprawdzanym rejestrze.
Test aktualności porównuje cały tekst wygenerowany z CSV, nie sam komentarz SHA.
-/
def leanData (r : Registry) (sha : String) : String := Id.run do
  let people := #[""] ++ sorted (unique (r.rows.map (·.person) |>.filter (!·.isEmpty)))
  let mut out := "-- PLIK GENEROWANY przez `tk_test lean` (Lean); nie edytować ręcznie.\n"
  out := out ++ s!"-- Źródło: dane/tk_rejestr.csv, SHA-256 {sha}\nimport Konstytucja.TK.Ciaglosc\n\nnamespace Konstytucja.TK.CiagloscDane\n\nset_option maxRecDepth 20000\n\ninductive Typ where\n"
  for n in [:types.size] do out := out ++ s!"  /-- {types[n]!.1}: {types[n]!.2} -/\n  | t{n}\n"
  out := out ++ "  deriving DecidableEq, Repr\n\nstructure Zdarzenie where\n  nr : Nat\n  typ : Typ\n  dzień : Nat\n  osoba : Nat\n  deriving DecidableEq, Repr\n\n"
  for n in [:people.size] do out := out ++ s!"-- {n}: {if people[n]!.isEmpty then "(brak osoby)" else people[n]!}\n"
  out := out ++ "\ndef rejestr : List Zdarzenie := [\n"
  for n in [:r.rows.size] do
    let w := r.rows[n]!
    let typ := (types.findIdx? (·.1 == w.typ)).getD 0
    let p := (people.findIdx? (· == w.person)).getD 0
    out := out ++ s!"  ⟨{n}, .t{typ}, {w.day - mkDate 1970 1 1}, {p}⟩{if n+1 < r.rows.size then "," else ""}  -- {w.id} {w.typ} {iso w.day} {w.person}\n"
  out := out ++ s!"]\n\ntheorem liczba_zdarzeń : rejestr.length = {r.rows.size} := by decide\n"
  out := out ++ "\n/-- Numery porządkowe; odrębny dowód poniżej sprawdza źródłowe ID. -/\ntheorem identyfikatory_unikalne : (rejestr.map (·.nr)).Nodup :=\n  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)\n"
  out := out ++ "\ndef wybrani : List Nat := (rejestr.filter (·.typ == .t1)).map (·.osoba)\n\ntheorem jeden_wybór : wybrani.Nodup :=\n  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)\n\ntheorem osoby_mają_wybór : rejestr.all (fun z => z.osoba == 0 || wybrani.contains z.osoba) = true := by decide\n"
  out := out ++ "\ndef źródłoweId : List String := [" ++ join ", " (r.rows.map (fun w => reprStr w.id)) ++ "]\n"
  out := out ++ "\n/-- F2: także źródłowe identyfikatory zdarzeń są unikalne. -/\ntheorem źródłowe_id_unikalne : źródłoweId.Nodup := by decide\n\nend Konstytucja.TK.CiagloscDane\n"
  return out

end Konstytucja.TK.Test
