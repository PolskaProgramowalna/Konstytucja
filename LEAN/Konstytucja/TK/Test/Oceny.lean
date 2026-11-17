import Konstytucja.TK.Test.Model

namespace Konstytucja.TK.Test

def fulfilled := "SPEŁNIONY"
def violated := "NARUSZONY"
def unknown := "NIEUSTALONY"
def uncovered := "NIEPOKRYTY"
def unprovided := "NIEPRZEWIDZIANE"
def notApplicable := "NIE DOTYCZY"
def rating (w : W3) : String := match w with | .tak => fulfilled | .nie => violated | .nieust => unknown
def combine (xs : Array String) : String :=
  if xs.contains violated then violated else if xs.contains unknown || xs.contains unprovided then unknown else fulfilled
structure Assessment where
  key : String := ""
  result : String := unknown
  norms : String := ""
  assumptions : String := ""
  sources : Array String := #[]
  notes : Array String := #[]
  deriving Repr, Inhabited
abbrev Cache := Std.HashMap String Assessment

def step5 (s : State) : Array Assessment := Id.run do
  let mut out := #[]
  for w in s.choices do
    if w.root || w.row.day < tStart then continue
    let z := s!"Z7={iv s.interpretation "z7"} Z12={iv s.interpretation "z12"} Z4={iv s.interpretation "z4"}"
    let base : Assessment := {norms := "W1", assumptions := z, sources := w.row.sources}
    let r := fun k => ((w.reasons.find? (·.1 == k)).map (·.2)).getD .nieust
    out := out.push {base with key := s!"E1:{w.person}:tryb", result := rating (r "tryb"), norms := "W1 W12"}
    out := out.push {base with key := s!"E1:{w.person}:indywidualność", result := rating (r "indywidualność")}
    if w.reasons.any (·.1 == "wakat_nieustalony") then
      out := out.push {base with key := s!"E1:{w.person}:wakat", notes := #["dokumenty nie wskazują zamierzonego wakatu (D1)"]}
    else
      out := out.push {base with key := s!"E1:{w.person}:wyprzedzający", result := rating (r "wyprzedzający").not, norms := "W1 W13"}
      out := out.push {base with key := s!"E1:{w.person}:wakat_wolny", result := rating (r "zajęty").not}
    for (name,note) in #[("ponowny_wybór","rejestr nie obejmuje wyborów sprzed 2006 r."),("wiedza_prawnicza","kryterium ocenne poza obliczeniem")] do
      out := out.push {base with key := s!"E1:{w.person}:{name}", result := uncovered, assumptions := "-", notes := #[note]}
    if !(w.row.a "poczatek").isEmpty && w.free.any (fun c => c.known && iso c.lo != w.row.a "poczatek") then
      out := out.push {base with key := s!"E1:{w.person}:data_początku_uchwały", norms := "W1 L2", notes := #["rozbieżność konwencji dat; wymaga decyzji recenzenta"]}
  return out

/-- Wszystkie uzupełnienia tytułów, z korelacją na miejscu i kontrolowanym limitem.
`none` oznacza przekroczony limit, nigdy wynik pozytywny przez pominięcie danych. -/
def completions (s : State) (people : Array String) (d : Data) : Option (Array (Array (String × Bool))) := Id.run do
  let statuses := (unique people).filterMap fun o => s.byPerson[o]?.map (fun w => (o,w.titleAt d))
  let uncertain := statuses.filter (·.2 == .nieust)
  if uncertain.size > 16 then return none
  let mut out := #[]
  for mask in [:2^uncertain.size] do
    let mut result := statuses.map fun (o,v) => (o,v == .tak)
    for n in [:uncertain.size] do result := put result uncertain[n]!.1 (mask / 2^n % 2 == 1)
    let mut occupied : Array String := #[]; let mut ok := true
    for w in s.choices do
      if !w.place.isEmpty && w.titleAt d == .tak then occupied := occupied.push w.place
    for (o,_) in uncertain do
      let p := (s.find o).place
      if !p.isEmpty && ((result.find? (·.1 == o)).map (·.2)).getD false then
        if occupied.contains p then ok := false
        occupied := occupied.push p
    if ok then out := out.push result
  return some out
def aggregate (xs : Array Bool) : String :=
  if xs.isEmpty then unknown else if xs.all id then fulfilled else if xs.all (!·) then violated else unknown
def hasTitle (u : Array (String × Bool)) (o : String) : Bool := ((u.find? (·.1 == o)).map (·.2)).getD false

structure Leader where
  person : String := ""
  role : String := ""
  start : Data := 0
  stop : Option Data := none
  result : String := unknown
  assessments : Array Assessment := #[]
  deriving Inhabited, Repr
def currentLeader (ks : Array Leader) (d : Data) : String × String := Id.run do
  let mut selected : Option Leader := none
  for k in ks do
    if #["prezes","po_prezesa","kierowanie"].contains k.role && k.start ≤ d && k.stop.all (d < ·) then
      if selected.all (fun x => k.start ≥ x.start) then selected := some k
  return (selected.map (fun k => (k.person,k.result))).getD ("?",unknown)
def senior (s : State) (o : String) (d : Data) : String := Id.run do
  let w := s.find o
  if w.person.isEmpty || w.titleAt d == .nie then return violated
  let start := fun w : Choice => (w.title.find? (fun (p,_) => p.contains d != .nie)).map (·.1.start)
  let own := start w
  let mut certain := w.titleAt d == .tak && own.isSome
  for x in s.choices do
    if x.person == o || x.titleAt d == .nie then continue
    let some a := start x | certain := false; continue
    let some b := own | certain := false; continue
    if x.titleAt d == .tak && a.hi.any (b.lo > ·) then return violated
    if !(a.lo > b.hi.getD a.lo) then certain := false
  return if certain then fulfilled else unknown
def convener (s : State) (i : Interpretation) (zo : Row) (ks : Array Leader) : String := Id.run do
  let who := zo.a "zwolal"
  if who.isEmpty || who == "?" then return unknown
  for k in ks do
    if k.person == who && k.start ≤ zo.day && k.stop.all (zo.day < ·) then
      if k.role == "prezes" || k.role == "kierowanie" then return k.result
      if k.role == "po_prezesa" then
        return if iv i "z5z" == "a" then violated else if iv i "z5z" == "b" then senior s who zo.day else unknown
  return if iv i "z5z" == "b" then senior s who zo.day else if iv i "z5z" == "c" then unknown else violated

def choose (n : Nat) (xs : List α) : List (List α) :=
  match n,xs with
  | 0,_ => [[]]
  | _ ,[] => []
  | n+1,x::xs => (choose n xs).map (x::·) ++ choose (n+1) xs
def allocations (voters : Array String) (votes : Array (String × Nat)) : Array (Array (String × String)) := Id.run do
  let mut out := #[(voters,#[])]
  for (candidate,n) in votes do
    out := out.flatMap fun (free,assigned) =>
      ((choose n free.toList).toArray.map fun selected =>
        (free.filter (!selected.contains ·), assigned ++ selected.toArray.map (·,candidate)))
  return out.map (·.2)

def evaluateZO (s : State) (i : Interpretation) (zo : Row) (ks : Array Leader)
    (cache : Cache) (candidate : String) : Assessment × Cache := Id.run do
  let z := variantText i
  let base : Assessment := {key := s!"ZO:{zo.id}", norms := "W2", assumptions := z, sources := zo.sources}
  let present := zo.items "obecni"; let voters := zo.items "glosujacy"
  if present.isEmpty || present.any (·.toNat?.isSome) then
    return ({base with notes := #["lista obecnych nieustalona (D5)"]},cache)
  let allPeople := s.choices.filter (fun w => w.titleAt zo.day != .nie) |>.map (·.person)
  let who := convener s i zo ks
  let signature := join "|" ((sorted (unique (allPeople ++ present))).map fun o =>
    s!"{o}:{(s.titleAt o zo.day).text}:{(s.find o).place}")
  let key := s!"{zo.id}/{candidate}/{iv i "z3c"}/{iv i "z3q"}/{iv i "z3m"}/{iv i "z8"}/{iv i "z5z"}/{who}/{signature}"
  if let some x := cache[key]? then return (x,cache)
  let some us := completions s (unique (allPeople ++ present)) zo.day |
    let x := {base with notes := #["liczba uzupełnień ponad limit (P10)"]}
    return (x,cache.insert key x)
  let votes := ((zo.a "glosy").splitOn "+").toArray.filterMap fun p =>
    let ps := p.splitOn ":"
    if ps.length != 2 then none else ps[1]!.toNat?.map (ps[0]!,·)
  let assignments := if votes.isEmpty || voters.isEmpty then #[] else allocations voters votes
  let mut results : Array Bool := #[]
  for u in us do
    let allCount := (u.filter (·.2)).size
    let pc := (present.filter (hasTitle u)).size
    let vc := (voters.filter (hasTitle u)).size
    let quorum := if iv i "z3q" == "a" then pc ≥ 8 else 2*pc > allCount
    let mut majorities : Array Bool := #[]
    if votes.isEmpty || voters.isEmpty then majorities := #[true,false]
    for a in assignments do
      let v := (a.filter fun (o,c) => c == candidate && hasTitle u o).size
      majorities := majorities.push (if iv i "z3m" == "a" then v ≥ 8 else if iv i "z3m" == "b" then v*2 > vc else v*2 > pc)
    let z8 := iv i "z8" != "a" || present.all (hasTitle u)
    if who == unknown && iv i "z3c" == "a" then results := results ++ #[true,false]; continue
    let zw := iv i "z3c" != "a" || who == fulfilled
    for ok in majorities do results := results.push (quorum && ok && z8 && zw)
  let result := {base with result := aggregate results, notes := #[s!"zwołanie: {who}","odrębne głosowanie nad uchwałą: NIEPOKRYTY"]}
  return (result,cache.insert key result)

def step6 (r : Registry) (s : State) (i : Interpretation) (cache : Cache := {}) : Array Leader × Cache := Id.run do
  let acts := (r.types #["E7","E9"]).qsort (fun a b => a.day < b.day || (a.day == b.day && a.id < b.id))
  let mut out : Array Leader := #[]; let mut cache := cache
  for a in acts do
    let role := a.a "funkcja"; let w := s.find a.person
    let next := acts.filter fun b => b.day > a.day && (b.a "funkcja" == role ||
      (#["prezes","po_prezesa","kierowanie"].contains role && #["prezes","po_prezesa","kierowanie"].contains (b.a "funkcja")))
    let mut stop := minimumDate (next.map (·.day))
    for e in r.forPerson a.person #["E10P"] do
      if e.a "funkcja" == role && e.day > a.day then stop := some (min e.day (stop.getD e.day))
    let base : Assessment := {key := s!"E7:{a.id}", norms := "W2", sources := a.sources}
    if role == "po_prezesa" then
      out := out.push ⟨a.person,role,a.day,stop,unprovided,#[{base with result := unprovided}]⟩; continue
    let title := s.titleAt a.person a.day
    if role == "kierowanie" then
      let v := if iv i "z5z" == "a" then
          if out.any (fun k => k.role == "wiceprezes" && k.person == a.person) then fulfilled else violated
        else if iv i "z5z" == "b" then senior s a.person a.day else unknown
      let v := if title == .nie then violated else if title == .nieust && v == fulfilled then unknown else v
      out := out.push ⟨a.person,role,a.day,stop,v,#[{base with key := s!"E9:{a.id}",result := v,assumptions := variantText i}]⟩
      continue
    let mut assessments := #[]; let mut results := #[]
    if role == "prezes" then
      match r.byId (a.a "zo") with
      | none => results := results.push unknown; assessments := assessments.push {base with key := s!"E7:{a.id}:a", notes := #["brak danych o uchwale ZO"]}
      | some zo =>
        let (z,c) := evaluateZO s i zo out cache a.person; cache := c
        assessments := assessments.push z; results := results.push z.result
        let v := if (zo.items "kandydaci").contains a.person then fulfilled else violated
        results := results.push v
        assessments := assessments.push {base with key := s!"E7:{a.id}:c", result := v, sources := a.sources ++ zo.sources}
    else
      results := results.push unknown
      assessments := assessments.push {base with key := s!"E7:{a.id}:a", notes := #["brak danych o uchwale ZO dla Wiceprezesa"]}
    results := results.push (rating title)
    assessments := assessments.push {base with key := s!"E7:{a.id}:tytuł",result := rating title,norms := "W1 W2",assumptions := variantText i}
    if !a.certain then results := results.push unknown
    if let some p := w.title.toList.getLast? then
      if let some e := p.1.stop then stop := some (min e.lo (stop.getD e.lo))
    if iv i "z5" == "b" then
      let e := plusYears a.day 6; stop := some (min e (stop.getD e))
    for e in r.forPerson a.person #["E10","E6a","E4-"] do
      if e.day > a.day then stop := some (min e.day (stop.getD e.day))
    out := out.push ⟨a.person,role,a.day,stop,combine results,assessments⟩
  return (out,cache)

def z13Unanimous (people : Array String) (s : State) (d : Data) (i : Interpretation) : String :=
  match completions s people d with
  | none => unknown
  | some us =>
    let xs := us.map fun u => decide ((people.filter (hasTitle u)).size > 0)
    if !xs.isEmpty && xs.all (!·) then "WADLIWE"
    else if iv i "z11" == "b" && !xs.isEmpty && xs.all id then uncovered else unknown
structure Decision where
  row : Row := {}
  detected : Array String := #[]
  effects : Array String := #[]
  result : String := "NIEUSTALONE"
  deriving Inhabited, Repr
def step7 (r : Registry) (s : State) (i : Interpretation) (ks : Array Leader) : Array Decision := Id.run do
  let mut out := #[]
  for row in (r.types #["ORZ"]).qsort (fun a b => a.day < b.day) do
    if row.day < tStart then continue
    let people := row.items "sklad"
    let titles := people.map (s.titleAt · row.day)
    let a := if people.isEmpty then unknown else if titles.contains .nie then "TAK" else if titles.all (· == .tak) then "NIE" else unknown
    let ea := if a == "NIE" then "BEZ WADY" else if iv i "z13" == "a" then
        if a == "TAK" then "WADLIWE" else unknown
      else if row.a "wynik" == "jednoglosnie" && !people.isEmpty && a != unknown then z13Unanimous people s row.day i else unknown
    let leader := (currentLeader ks row.day).2
    let b := if leader == violated then "TAK" else if leader == fulfilled then "NIE" else unknown
    let eb := if iv i "z9" != "a" then "BEZ WADY" else if b == "TAK" then "WADLIWE" else if b == "NIE" then "BEZ WADY" else unknown
    let c := if #["jednoglosnie","wiekszoscia"].contains (row.a "wynik") then "NIE" else unknown
    let ec := if c == "NIE" then "BEZ WADY" else unknown
    let dd := if iv i "z11" == "a" then unknown else uncovered
    let conflict := (row.items "dotyczy_tytulu").any people.contains ||
      (iv i "z10" == "b" && (row.items "przepisy_tytulu").any people.contains)
    let e := if people.isEmpty then unknown else if conflict then "TAK" else "NIE"
    let ee := if e == "TAK" then if iv i "z14" == "a" then "WADLIWE" else unknown else if e == unknown then unknown else "BEZ WADY"
    let effects := #[ea,eb,ec,dd,ee]
    let result := if effects.contains "WADLIWE" then "WADLIWE" else if effects.contains unknown then "NIEUSTALONE" else "BEZ WYKRYTEJ WADY"
    out := out.push ⟨row,#[a,b,c,dd,e],effects,result⟩
  return out

structure Publication where
  row : Row := {}
  result : String := unknown
  published : Option Data := none
  elapsed : Nat := 0
  cause : String := unknown
  violationStart : Option Data := none
  events : Array String := #[]
  notes : Array String := #[]
  deriving Inhabited, Repr
def step8 (r : Registry) : Array Publication := Id.run do
  let mut out := #[]
  for row in (r.types #["ORZ"]).qsort (fun a b => a.day < b.day) do
    if row.day < tStart then continue
    let events := (r.types #["PUB"]).filter (fun p => p.a "sprawa" == row.a "sprawa")
    let p3 := minimumDate ((events.filter (fun p => p.a "zdarzenie" == "O3")).map (·.day))
    let p2 := events.filter (fun p => p.a "zdarzenie" == "O2" && p.certain)
    let evals := (r.types #["OCENA"]).filter (fun p => p.a "warunek" == s!"W6b:{row.a "sprawa"}" && p.a "status" == "zatwierdzona")
    let mut p : Publication := {
      row := row, published := p3, elapsed := p3.getD tEnd - row.day,
      events := events.map (fun e => s!"{e.a "zdarzenie"} {iso e.day}")}
    if row.a "art188" != "tak" then
      p := {p with result := notApplicable,cause := "-",notes := #["orzeczenie poza art. 188 (np. kontrola prewencyjna)"]}
    else if !p2.isEmpty then
      p := {p with result := violated,cause := p2[0]!.a "organ", violationStart := minimumDate (p2.map (·.day))}
    else if let some e := evals[0]? then
      let res := match e.a "wynik" with | "spelniony" => fulfilled | "naruszony" => violated | _ => unknown
      p := {p with result := res,cause := if res == violated then e.a "organ" "-" else if res == unknown then unknown else "-",notes := #[s!"ocena {e.id} ({e.a "autor"})"]}
    else
      if events.any (fun e => e.a "zdarzenie" == "O1") && !events.any (fun e => e.a "zdarzenie" == "O2") then
        p := {p with notes := p.notes.push "tylko zapowiedź (O1); nie jest odmową wykonaną"}
      if p3.isNone then p := {p with notes := p.notes.push "sam upływ czasu nie rozstrzyga W6b (R-PUB)"}
    out := out.push p
  return out

end Konstytucja.TK.Test
