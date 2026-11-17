import Konstytucja.TK.Test.Podstawy

namespace Konstytucja.TK.Test

abbrev Segments := Array (Przedzial × W3)
def segmentStatus (ps : Segments) (d : Data) : W3 := ps.foldl (fun a (p,s) => a.or ((p.contains d).and s)) .nie
structure Choice where
  person : String := ""
  row : Row := {}
  place : String := ""
  previous : String := ""
  root : Bool := false
  free : Option Chwila := none
  admissible : W3 := .nieust
  reasons : Array (String × W3) := #[]
  effective : Option Chwila := none
  effectiveStatus : W3 := .nie
  entry : Option Chwila := none
  entryStatus : W3 := .nie
  start : Option Chwila := none
  stop : Option Chwila := none
  claimEnd : Option Chwila := none
  unentered : W3 := .nie
  title : Segments := #[]
  activity : Segments := #[]
  disputed : Bool := false
  healed : Bool := false
  deriving Inhabited, Repr
def Choice.titleAt (w : Choice) (d : Data) : W3 := segmentStatus w.title d
def Choice.activeAt (w : Choice) (d : Data) : W3 := segmentStatus w.activity d
structure State where
  interpretation : Interpretation := #[]
  alternative : Array (String × String) := #[]
  choices : Array Choice := #[]
  byPerson : Std.HashMap String Choice := {}
  places : Array String := #[]
  deriving Inhabited
def State.find (s : State) (o : String) : Choice := s.byPerson[o]?.getD {}
def State.titleAt (s : State) (o : String) (d : Data) : W3 :=
  (s.byPerson[o]?.map (·.titleAt d)).getD .nieust
def State.boundaries (s : State) : Array Data :=
  let ds := s.choices.foldl (fun ds w => ds ++
    (w.title ++ w.activity).flatMap (fun (p,_) => p.boundaries) ++
    (#[w.effective,w.claimEnd].flatMap fun c => (c.map fun t => #[t.lo] ++ t.hi.toArray).getD #[])) #[tStart]
  (unique (ds.filter fun d => tStart ≤ d && d < tEnd)).qsort (· < ·)

def alternativeKey (r : Registry) (a : Array (String × String)) : String := Id.run do
  let order := (a.qsort fun x y =>
    let wx := (r.election x.1).getD {}; let wy := (r.election y.1).getD {}
    wx.day < wy.day || (wx.day == wy.day && x.1 < y.1))
  let mut numbers : Array (String × String) := #[]
  let mut out : Array String := #[]
  for (o,v) in order do
    if v.isEmpty then out := out.push s!"{o}:?"; continue
    let prev := (v.drop 2).toString
    let w := (r.election prev).getD {}
    let cls := if w.id.isEmpty || !w.vacancy.isEmpty ||
      !(r.forPerson prev #["E2","E3","E4","E4-","E5","E6a","E6b","E10"]).isEmpty then v
      else s!"class:{w.a "poczatek"}:{w.day}"
    if !cls.startsWith "class:" then out := out.push s!"{o}:{v}"; continue
    if (get numbers v).isEmpty then
      let n := (numbers.filter fun (_,x) => x.startsWith (cls ++ "#")).size
      numbers := numbers.push (v,s!"{cls}#{n}")
    out := out.push s!"{o}:{get numbers v}"
  return join "|" out

def coherent (r : Registry) (a : Array (String × String)) : Bool := Id.run do
  let mut groups : Array (String × String) := #[]
  for w in r.types #["E1"] do
    let v := get a w.person
    let g := w.a "grupa"
    if !g.isEmpty && !v.isEmpty then
      if groups.contains (g,v) then return false
      groups := groups.push (g,v)
    let same := w.a "wspolny_wakat"
    if !same.isEmpty && !v.isEmpty && get a same != v then return false
  return true

def alternatives (r : Registry) : Array (Array (String × String)) := Id.run do
  let es := r.types #["E1"]
  let mut out : Array (Array (String × String)) := #[#[]]
  for w in es do
    let opts := if w.vacancy == "?" || w.vacancy.isEmpty then #[""] else (w.vacancy.splitOn "|").toArray
    out := out.flatMap (fun a => opts.map fun v => a.push (w.person,v))
  let mut seen : Std.HashSet String := {}; let mut result := #[]
  for a in out do
    if !coherent r a then continue
    let k := alternativeKey r a
    if seen.contains k then continue
    seen := seen.insert k; result := result.push a
  return result

def actualStart (w : Row) (ad : Assumptions) : Chwila :=
  match (parseDate (w.a "poczatek")).toOption with
  | some d => exactDate d
  | none => if ad.ad4 then exactDate w.day else ⟨plusYears w.day (-1),some (plusYears w.day 1)⟩
def deathOrRetirement (r : Registry) (o : String) : Option Chwila :=
  (r.forPerson o #["E6a","E6b"]).foldl (fun a w => some ((a.map (cmin · w.time)).getD w.time)) none
def oath (r : Registry) (ad : Assumptions) (w : Choice) : Option Chwila :=
  let e2 := r.forPerson w.person #["E2"]
  match e2.find? (fun e => e.a "forma" == "wobec_prezydenta") with
  | some e => some (if e.certain then e.time else ⟨e.time.lo,none⟩)
  | none =>
    if (r.forPerson w.person #["E3"]).isEmpty && ad.ad2 &&
      !e2.any (fun e => e.a "forma" != "wobec_prezydenta") then
      some (cmax (exactDate w.row.day) (actualStart w.row ad))
    else none
def termEnd (r : Registry) (d : Data) : Chwila :=
  match (r.types #["SEJM"]).find? (fun s => s.day ≤ d && ((parseDate (s.a "do")).toOption.all (d ≤ ·))) with
  | some s => ((parseDate (s.a "do")).toOption.map exactDate).getD ⟨tEnd,none⟩
  | none => ⟨d,none⟩
abbrev Claim := String × Chwila × Option Chwila × W3
def occupied (cs : Array Claim) (t : Chwila) : W3 :=
  cs.foldl (fun out (_,start,stop,st) => out.or ((Przedzial.containsTime ⟨start,stop⟩ t).and st)) .nie
def occupationEnd (cs : Array Claim) (t : Chwila) : Option Chwila := Id.run do
  let cs := cs.filter (fun (_,a,b,_) => (Przedzial.containsTime ⟨a,b⟩ t) != .nie)
  if cs.isEmpty then return none
  if cs.any (fun (_,_,b,_) => b.isNone) then return some ⟨t.lo,none⟩
  return cs.foldl (fun out (_,_,b,_) => some ((out.map (cmax · b.get!)).getD b.get!)) none

def electionProcedure (i : Interpretation) (w : Row) : W3 := Id.run do
  if iv i "z12" == "b" then return .nieust
  if !(w.a "lista").isEmpty then
    let ps := (w.a "lista").splitOn "/"
    let a := ps[0]!.toNat?.getD 0; let b := ps[1]!.toNat?.getD 0
    return wb (a+b ≥ 230 && a > b)
  if !(w.a "za").toNat?.isSome || !(w.a "przeciw").toNat?.isSome then return .nieust
  let a := (w.a "za").toNat?.getD 0; let b := (w.a "przeciw").toNat?.getD 0
  let c := (w.a "wstrz").toNat?.getD 0
  return wb (a+b+c ≥ 230 && a > b)

def election (r : Registry) (i : Interpretation) (ad : Assumptions) (w : Choice)
    (previous : Std.HashMap String Choice) (claims : Array Claim) : Choice := Id.run do
  let mut w := w
  let d := exactDate w.row.day
  let free := if w.root then some (actualStart w.row ad) else
    match previous[w.previous]? with
    | none => none
    | some p => p.claimEnd.orElse (fun _ => p.stop) |>.orElse (fun _ =>
      let k := (actualStart p.row ad).years 9
      some ((deathOrRetirement r p.person).map (cmin k) |>.getD k))
  w := {w with free := free}
  let mut rs : Array (String × W3) := #[]
  if w.root then rs := #[("stan_wyjściowy",.tak)]
  else
    rs := rs.push ("tryb", electionProcedure i w.row)
    rs := rs.push ("indywidualność", if #["odrebne","lista"].contains (w.row.a "glosowanie") then .tak else .nieust)
    if free.isNone || w.place.isEmpty then
      rs := rs ++ #[("wakat_nieustalony",.tak),("wyprzedzający",.nieust),("zajęty",.nieust)]
    else
      let ok := if iv i "z7" == "a" then noLater free.get! d
        else if iv i "z7" == "b" then noLater free.get! (termEnd r w.row.day) else .tak
      rs := rs ++ #[("wyprzedzający",ok.not),("zajęty",occupied claims (cmax free.get! d))]
  let getR := fun key => ((rs.find? (·.1 == key)).map (·.2)).getD .nieust
  let s2 := rs.foldl (fun a (k,v) => a.and (if #["tryb","indywidualność","stan_wyjściowy"].contains k then v
    else if k == "wakat_nieustalony" then .nieust else v.not)) .tak
  w := {w with reasons := rs, admissible := s2}
  let mut eff : Option Chwila := none; let mut effStatus : W3 := .nie; let mut healed := false
  if w.root then eff := free; effStatus := .tak
  else if s2 == .tak then eff := some (cmax free.get! d); effStatus := .tak
  else if s2 == .nieust then
    let b := (free.map (cmax · d)).getD d
    eff := some (if iv i "z4" != "a" then ⟨b.lo,none⟩ else b); effStatus := .nieust
  else
    let hard := getR "tryb" == .nie || getR "indywidualność" == .nie
    let advance := getR "wyprzedzający" == .tak
    if !hard && iv i "z4" != "a" && !(advance && iv i "z4" != "bR2") then
      let b := cmax free.get! d
      eff := some (if getR "zajęty" == .tak then (occupationEnd claims b).map (cmax b) |>.getD b else b)
      effStatus := .tak; healed := true
  w := {w with effective := eff, effectiveStatus := if eff.isNone then .nie else effStatus, healed := healed}
  let some ed := eff | return w
  let x := oath r ad w
  let e3 := !(r.forPerson w.person #["E3"]).isEmpty
  let mut entry := none; let mut es := .nie
  if iv i "z1" == "a" then entry := some ed; es := effStatus
  else if iv i "z1" == "b" then
    if let some x := x then entry := some (cmax ed x); es := effStatus
    else if !e3 then entry := some ⟨ed.lo,none⟩; es := .nieust
  else if iv i "z1" == "c" then
    entry := some ((x.map (cmax ed)).getD ed); es := if x.isSome then effStatus else .nieust
  else
    let fiction := ed.days (((iv i "z1").drop 1).toString.toNat?.getD 0)
    entry := some ((x.map fun x => cmin (cmax ed x) fiction).getD fiction); es := effStatus
  let sa := if healed || free.isNone then ed else free.get!
  let endA := sa.years 9
  let start := if iv i "z2" == "b" then entry.getD sa else sa
  let stop := start.years 9
  let s8 := (entry.map (fun e => (before e endA).not)).getD .tak
  let retirement := deathOrRetirement r w.person
  let endClaim := if entry.isSome && iv i "z2" == "b" then stop else endA
  let mut title : Segments := #[]
  if let some e := entry then
    if s8 != .tak then
      let st := if s8 == .nie then es else .nieust
      title := #[(⟨e,(retirement.map (cmin stop)).getD stop⟩,st)]
  if retirement.isNone && !ad.ad1 then title := title.map (fun (p,_) => (p,.nieust))
  return {w with
    entry := entry, entryStatus := es, start := some start, stop := some stop,
    claimEnd := some ((retirement.map (cmin endClaim)).getD endClaim), unentered := s8, title := title}

def activity (r : Registry) (ad : Assumptions) (w : Choice) : Choice := Id.run do
  let e3 := !(r.forPerson w.person #["E3"]).isEmpty
  let e5 := (r.forPerson w.person #["E5"]).map (·.day)
  let explicitStops := (r.forPerson w.person #["E4-","E6a","E10"]).map (·.time)
  let endFact := (actualStart w.row ad).years 9
  let mut stops := explicitStops
  if stops.isEmpty && ad.ad5 && !w.disputed && !e5.any (· ≥ endFact.lo) then stops := stops.push endFact
  let mut starts := (r.forPerson w.person #["E4"]).map (·.time)
  if starts.isEmpty && !e3 && ad.ad3 then
    if let some x := (oath r ad w).orElse (fun _ => if w.root then w.free else none) then starts := starts.push x
  let events := ((starts.map (·,false)) ++ (stops.map (·,true))).qsort fun (a,x) (b,y) =>
    a.lo < b.lo || (a.lo == b.lo && !x && y)
  let mut opened : Option Chwila := none; let mut intervals : Array Przedzial := #[]
  for (c,stop) in events do
    if !stop && opened.isNone then opened := some c
    else if stop && opened.isSome then intervals := intervals.push ⟨opened.get!,some c⟩; opened := none
  if let some c := opened then intervals := intervals.push ⟨c,none⟩
  let mut segments : Segments := #[]
  if starts.isEmpty then
    let first := if e3 && ad.ad7 then e5[0]? else some w.row.day
    if let some d := first then
      let stop := (explicitStops.filter (·.lo ≥ d)).qsort (fun a b => a.lo < b.lo) |>.toList.head?
      segments := segments.push (⟨exactDate d,stop⟩,.nieust)
  let endTitle := (w.title.toList.getLast?.bind (·.1.stop)).orElse (fun _ => if w.title.isEmpty then some endFact else none)
  for p in intervals do
    if endTitle.isNone || p.stop.any (fun e => noLater e endTitle.get! == .tak) then
      segments := segments.push (p,.tak)
    else if endTitle.get!.lo ≤ p.start.lo then segments := segments.push (p,.nieust)
    else
      let e := exactDate endTitle.get!.lo
      segments := segments.push (⟨p.start,some e⟩,.tak) |>.push (⟨e,p.stop⟩,.nieust)
  for d in e5 do segments := segments.push (⟨exactDate d,some (exactDate (d+1))⟩,.tak)
  return {w with activity := segments}

def calculate (r : Registry) (i : Interpretation) (alt : Array (String × String)) (ad : Assumptions := {}) : State := Id.run do
  let mut disputed := (r.types #["E3"]).map (·.person)
  for u in r.types #["UCHWALA_STATUS"] do disputed := disputed ++ u.items "dotyczy"
  for w in r.types #["E1"] do if w.vacancy.contains '|' then disputed := disputed.push w.person
  let roots := (r.types #["E1"]).filter (·.vacancy.isEmpty)
  let mut state : State := {interpretation := i, alternative := alt, places := roots.map (fun w => s!"M.{w.person}")}
  let es := (r.types #["E1"]).qsort (fun a b => a.day < b.day || (a.day == b.day && a.id < b.id))
  let mut claims : Std.HashMap String (Array Claim) := {}
  for row in es do
    let prev := if row.vacancy.isEmpty then "" else ((get alt row.person).drop 2).toString
    let root := row.vacancy.isEmpty
    let place := if root then s!"M.{row.person}" else (state.byPerson[prev]?.map (·.place)).getD ""
    let w : Choice := {
      person := row.person, row := row, previous := prev, place := place,
      root := root, disputed := disputed.contains row.person}
    let w := election r i ad w state.byPerson (claims[place]?.getD #[])
    state := {state with choices := state.choices.push w, byPerson := state.byPerson.insert w.person w}
    if !place.isEmpty then
      if let some eff := w.effective then
        claims := claims.insert place ((claims[place]?.getD #[]).push (w.person,eff,w.claimEnd,w.effectiveStatus))
  let choices := state.choices.map (activity r ad)
  return {state with choices := choices, byPerson := choices.foldl (fun m w => m.insert w.person w) {}}

structure Bounds where
  lo : Nat := 0
  hi : Nat := 0
  deriving BEq, Repr, Inhabited
def Bounds.text (b : Bounds) : String := if b.lo == b.hi then toString b.lo else s!"{b.lo}–{b.hi}"
def counters (s : State) (d : Data) : Array Bounds := Id.run do
  let mut t : Bounds := {}; let mut f : Bounds := {}; let mut b : Bounds := {}
  let mut w : Bounds := {}; let mut z : Bounds := {}; let mut u : Bounds := {}
  for m in s.places do
    let xs := s.choices.filter (·.place == m)
    let titles := xs.map (·.titleAt d)
    let claims := xs.map fun x => (x.effective.map fun e => (Przedzial.contains ⟨e,x.claimEnd⟩ d).and x.effectiveStatus).getD .nie
    t := ⟨t.lo + (if titles.contains .tak then 1 else 0),t.hi + (if titles.any (· != .nie) then 1 else 0)⟩
    let certain := (claims.filter (· == .tak)).size
    let possible := (claims.filter (· != .nie)).size
    w := ⟨w.lo + (if possible == 0 then 1 else 0),w.hi + (if certain == 0 then 1 else 0)⟩
    let blocked := (claims.zip titles).any (fun (c,t) => c != .nie && t != .tak)
    let blockedCertain := (claims.zip titles).any (fun (c,t) => c == .tak && t == .nie)
    z := ⟨z.lo+(if blockedCertain then 1 else 0),z.hi+(if blocked then 1 else 0)⟩
    u := ⟨u.lo+(if certain > 1 then 1 else 0),u.hi+(if possible > 1 || claims.contains .nieust then 1 else 0)⟩
  let mut unknown := 0
  for x in s.choices do
    let title := x.titleAt d; let active := x.activeAt d
    if x.place.isEmpty && title != .nie then unknown := unknown+1
    f := ⟨f.lo+(if active == .tak then 1 else 0),f.hi+(if active != .nie then 1 else 0)⟩
    b := ⟨b.lo+(if active == .tak && title == .nie then 1 else 0),b.hi+(if active != .nie && title != .tak then 1 else 0)⟩
  return #[{t with hi := min 15 (t.hi+unknown)},f,b,w,z,u]

end Konstytucja.TK.Test
