import Konstytucja.TK.Test.Oceny

namespace Konstytucja.TK.Test

abbrev Counts := Std.HashMap String Nat
def countAdd (cs : Counts) (k : String) (n : Nat := 1) : Counts := cs.insert k (cs[k]?.getD 0+n)
def mergeCounts (a b : Counts) : Counts := b.fold (fun a k n => countAdd a k n) a
def countText (c : Counts) : String := join "; " ((c.toArray.qsort (fun a b => a.1 < b.1)).map fun (v,n) => s!"{v}: {n}")
structure Aggregate where
  counts : Counts := {}
  margins : Std.HashMap String (Array String) := {}
  deriving Inhabited
def marginAdd (ms : Std.HashMap String (Array String)) (k : String) (v : String) :=
  ms.insert k (unique ((ms[k]?.getD #[]).push v))
def Aggregate.add (a : Aggregate) (v : String) (i : Interpretation) (alt : Nat) (weight := 1) : Aggregate := Id.run do
  let mut m := a.margins
  for (p,x) in i do m := marginAdd m s!"{p}:{x}" v
  m := marginAdd m s!"A:{alt}" v
  return ⟨countAdd a.counts v weight,m⟩
def Aggregate.addBatch (a : Aggregate) (other : Aggregate) (i : Interpretation) (alt : Nat) : Aggregate := Id.run do
  let mut m := a.margins
  for v in other.counts.keysArray do
    for (p,x) in i do m := marginAdd m s!"{p}:{x}" v
    m := marginAdd m s!"A:{alt}" v
  for (k,vs) in other.margins.toArray do
    for v in vs do m := marginAdd m k v
  return ⟨mergeCounts a.counts other.counts,m⟩
def Aggregate.influences (a : Aggregate) : Array String := Id.run do
  let mut out := #[]
  for p in parameterNames.push "A" do
    let sets := a.margins.toArray.filterMap fun (k,vs) => if k.startsWith (p++":") then some (join "|" (sorted vs)) else none
    if (unique sets).size > 1 then out := out.push p
  return sorted out
structure Trace where
  norms : String := ""
  sources : Array String := #[]
  intervals : Array String := #[]
  deriving Inhabited
structure Result where
  aggregates : Std.HashMap String Aggregate := {}
  exactInfluence : Std.HashMap String (Array String) := {}
  envelope : Std.HashMap Data (Array Bounds) := {}
  daily : Std.HashMap Data (Array (Array String)) := {}
  publications : Array Publication := #[]
  annual : Std.HashMap String Counts := {}
  trace : Std.HashMap String Trace := {}
  counts : Array Nat := #[0,0,0]
  alternatives : Array (Array (String × String)) := #[]
  assumptions : Assumptions := {}
  partialRun : Bool := false
  deriving Inhabited
def addAssessment (w : Result) (a : Assessment) (i : Interpretation) (alt : Nat) (lead := "") : Result :=
  let k := lead ++ a.key
  {w with
    aggregates := w.aggregates.insert k ((w.aggregates[k]?.getD {}).add a.result i alt),
    trace := w.trace.insert k {norms := a.norms,sources := a.sources}}
def m1Values (s : State) : Array (String × String) := Id.run do
  let mut out := (step5 s).map fun a => (a.key,a.result)
  for w in s.choices do
    if w.row.day < tStart then continue
    out := out.push (s!"S4:{w.person}", (w.effective.map fun d => s!"{w.effectiveStatus.text} od {d.text}").getD "BRAK")
    let title := join "; " (w.title.map fun (p,v) => s!"[{p.start.text}, {(p.stop.map (·.text)).getD "None"}) {v.text}")
    out := out.push (s!"tytuł:{w.person}", if title.isEmpty then "BRAK" else title)
    out := out.push (s!"S8:{w.person}",w.unentered.text)
  return out
def dailyClass (l : Array Bounds) : Array String := Id.run do
  let t := l[0]!; let f := l[1]!; let b := l[2]!
  let k1 := if t.hi < 8 then "TAK" else if t.lo ≥ 8 then "NIE" else unknown
  let k2 := if b.lo > 0 then "TAK" else if b.hi == 0 then "NIE" else unknown
  let k3 := if f.hi == 0 then "BRAK OSÓB W FUNKCJI" else if b.lo*3 ≥ f.hi then "TAK"
    else if f.lo != 0 && b.hi*3 < f.lo then "NIE" else unknown
  return #[k1,k2,k3]

/-- Progi są całkowitymi procentami; bez błędów zaokrągleń float. -/
def defectiveShare (bad uncertain registered : Nat) (total : Option Nat) (percent : Nat) : W3 :=
  match total with
  | none | some 0 => .nieust
  | some n =>
    if bad*100 ≥ percent*n then .tak
    else if (bad+uncertain+(n-registered))*100 < percent*n then .nie else .nieust
def leadershipInYear (ks : Array Leader) (year : Nat) : W3 := Id.run do
  let start := max (mkDate year 1 1) tStart
  let stop := min (mkDate (year+1) 1 1) tEnd
  let seg := (ks.filter fun k => #["prezes","po_prezesa","kierowanie"].contains k.role && k.start < stop && k.stop.all (· > start)).qsort (fun a b => a.start < b.start)
  if seg.any (·.result == violated) then return .tak
  let mut covered := start
  for k in seg do
    if k.result != fulfilled || k.start > covered then return .nieust
    covered := max covered (k.stop.getD stop)
    if covered ≥ stop then return .nie
  return .nieust
def years : Array Nat := (List.range 12).toArray.map (·+2015)
def thresholds : Array Nat := #[10,25,50]
structure Summary where
  judgments : Std.HashMap String Aggregate := {}
  shares : Std.HashMap String Counts := {}
  deriving Inhabited
def summarize (r : Registry) (s : State) (base : Interpretation) (ks : Array Leader) : Summary := Id.run do
  let mut out : Summary := {}
  let annual := r.types #["D6_ROK"]
  for i in variants 3 base do
    let mut nums : Std.HashMap Nat (Nat × Nat × Nat) := {}
    let ext := i.filter (fun (p,_) => !(deps 2).contains p)
    for d in step7 r s i ks do
      let key := d.row.a "sprawa"
      let a := (out.judgments[key]?.getD {}).add d.result ext 0
      -- A jest dodawane dopiero przy złączeniu; wewnętrzny indeks 0 nie jest alternatywą danych.
      let a := {a with margins := a.margins.erase "A:0"}
      out := {out with judgments := out.judgments.insert key a}
      if d.row.a "art188" == "tak" then
        let y := (parts d.row.day).1
        let (b,u,n) := nums[y]?.getD (0,0,0)
        nums := nums.insert y (b+(if d.result == "WADLIWE" then 1 else 0),u+(if d.result == "NIEUSTALONE" then 1 else 0),n+1)
    for y in years do
      let (b,u,n) := nums[y]?.getD (0,0,0)
      let total := (annual.find? (fun w => (w.a "rok").toNat? == some y)).bind (fun w => (w.a "liczba").toNat?)
      for x in thresholds do
        let key := s!"{y}:{x}"; let v := (defectiveShare b u n total x).text
        out := {out with shares := out.shares.insert key (countAdd (out.shares[key]?.getD {}) v)}
  return out
def wordW3 (s : String) : W3 := if s == "TAK" then .tak else if s == "NIE" then .nie else .nieust

/-- Pełny przegląd modułów; limit służy wyłącznie jawnym próbom technicznym.
Tablicowanie M3 jest lokalne dla jednego stanu M1 i jednej alternatywy danych.
Nie wymaga niezależnego powielenia parametrów ani przenoszenia korelacji między stanami.
-/
def run (r : Registry) (ad : Assumptions := {}) (limit : Option Nat := none) (maxModule := 3) : Result := Id.run do
  let alts := alternatives r
  let m1 := (variants 1).extract 0 (limit.getD (variants 1).size)
  let mut out : Result := {alternatives := alts,assumptions := ad,publications := step8 r,partialRun := limit.isSome || maxModule < 3}
  let mut states : Array (Nat × Interpretation × State) := #[]
  let mut dates : Array Data := #[]
  for ai in [:alts.size] do
    for i in m1 do
      let s := calculate r i alts[ai]! ad
      states := states.push (ai,i,s); dates := dates ++ s.boundaries
  dates := (unique dates).qsort (· < ·)
  let mut zoCache : Cache := {}
  let mut firstValues : Std.HashMap String (Array (String × String)) := {}
  let judgments := (r.types #["ORZ"]).filter (·.day ≥ tStart)
  for (ai,i,s) in states do
    let r1 := m1Values s
    firstValues := firstValues.insert s!"{ai}:{variantText i}" r1
    out := {out with counts := out.counts.modify 0 (·+1)}
    for (k,v) in r1 do
      out := {out with aggregates := out.aggregates.insert k ((out.aggregates[k]?.getD {}).add v i ai)}
    for a in step5 s do out := {out with trace := out.trace.insert a.key ⟨a.norms,a.sources,#[]⟩}
    for d in dates do
      let l := counters s d
      let prev := out.envelope[d]?.getD l
      let env := prev.zip l |>.map fun (a,b) => ({lo := min a.lo b.lo,hi := max a.hi b.hi} : Bounds)
      let classes := dailyClass l
      let cls := out.daily[d]?.getD #[#[],#[],#[]]
      out := {out with
        envelope := out.envelope.insert d env,
        daily := out.daily.insert d ((cls.zip classes).map fun (a,v) => unique (a.push v))}
    if maxModule < 2 then continue
    let mut cache3 : Std.HashMap String Summary := {}
    for i2 in variants 2 i do
      let (ks,c) := step6 r s i2 zoCache; zoCache := c
      out := {out with counts := out.counts.modify 1 (·+1)}
      for k in ks do
        let key := s!"kierownictwo:{k.person}:{k.role}:{iso k.start}"
        out := {out with aggregates := out.aggregates.insert key ((out.aggregates[key]?.getD {}).add k.result i2 ai)}
        let tr := out.trace[key]?.getD {norms := "W2"}
        let tr := {tr with intervals := unique (tr.intervals.push s!"[{iso k.start}, {(k.stop.map iso).getD "…"})"),sources := unique (tr.sources ++ k.assessments.flatMap (·.sources))}
        out := {out with trace := out.trace.insert key tr}
        for a in k.assessments do out := addAssessment out a i2 ai "ocena:"
      if maxModule < 3 then continue
      let signature := join "|" (judgments.map fun d =>
        let (who,status) := currentLeader ks d.day; s!"{who}:{status}")
      let summary := match cache3[signature]? with
        | some v => v
        | none => summarize r s i2 ks
      cache3 := cache3.insert signature summary
      out := {out with counts := out.counts.modify 2 (·+extensionCount)}
      for (key,a) in summary.judgments.toArray do
        let k := "orzeczenie:" ++ key
        out := {out with aggregates := out.aggregates.insert k ((out.aggregates[k]?.getD {}).addBatch a i2 ai)}
      for y in years do
        let kw := leadershipInYear ks y
        for x in thresholds do
          let key := s!"{y}:{x}"
          let mut cs := out.annual[key]?.getD {}
          for (v,n) in (summary.shares[key]?.getD {}).toArray do cs := countAdd cs (kw.and (wordW3 v)).text n
          out := {out with annual := out.annual.insert key cs}
  for (ai,i,_) in states do
    let r1 := firstValues[s!"{ai}:{variantText i}"]?.getD #[]
    for p in deps 1 do
      for v in values p do
        if v == iv i p then continue
        let j := put i p v
        if identified j then continue
        if let some r2 := firstValues[s!"{ai}:{variantText j}"]? then
          for (k,v1) in r1 do
            if get r2 k != v1 then
              out := {out with exactInfluence := out.exactInfluence.insert k (unique ((out.exactInfluence[k]?.getD #[]).push p))}
  return out

end Konstytucja.TK.Test
