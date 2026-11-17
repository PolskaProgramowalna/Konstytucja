import Std

/-! Czysty rdzeń testu TK: kalendarz, niepewność, CSV, rejestr i warianty.
IO jest wyłącznie w Skrypty/TK.lean. Parametry mają status roboczy.
-/
namespace Konstytucja.TK.Test

def trim (s : String) : String := s.trimAscii.toString
def join (sep : String) (xs : Array String) : String := sep.intercalate xs.toList
def unique [BEq α] (xs : Array α) : Array α := xs.foldl (fun a x => if a.contains x then a else a.push x) #[]
def sorted (xs : Array String) : Array String := xs.qsort (· < ·)
def get (xs : Array (String × String)) (k : String) (fallback := "") : String :=
  ((xs.find? (·.1 == k)).map (·.2)).getD fallback
def put (xs : Array (String × α)) (k : String) (v : α) : Array (String × α) :=
  match xs.findIdx? (·.1 == k) with
  | some n => xs.set! n (k,v)
  | none => xs.push (k,v)

abbrev Data := Nat -- ordinal gregoriański, 0001-01-01 = 1
def minimumDate (xs : Array Data) : Option Data := xs.foldl (fun a d => some (min d (a.getD d))) none
def leap (y : Nat) : Bool := y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)
def yearStart (y : Nat) : Nat := 365*(y-1) + (y-1)/4 - (y-1)/100 + (y-1)/400 + 1
def monthDays (y m : Nat) : Nat :=
  if m == 2 then if leap y then 29 else 28
  else if #[4,6,9,11].contains m then 30 else 31
def mkDate (y m d : Nat) : Data := yearStart y + ((List.range (m-1)).map (fun n => monthDays y (n+1))).sum + d - 1
def parseDate (s : String) : Except String Data := do
  let ps := s.splitOn "-"
  unless ps.length == 3 do throw s!"niepoprawna data {s}"
  let some y := ps[0]!.toNat? | throw s!"niepoprawny rok {s}"
  let some m := ps[1]!.toNat? | throw s!"niepoprawny miesiąc {s}"
  let some d := ps[2]!.toNat? | throw s!"niepoprawny dzień {s}"
  unless y > 0 && m > 0 && m ≤ 12 && d > 0 && d ≤ monthDays y m do throw s!"niepoprawna data {s}"
  return mkDate y m d
def parts (d : Data) : Nat × Nat × Nat := Id.run do
  let mut y := d / 365 + 1
  for _ in [:y+1] do
    if yearStart y > d then y := y-1 else break
  let mut rest := d - yearStart y
  let mut m := 1
  for _ in [:11] do
    if rest ≥ monthDays y m then
      rest := rest - monthDays y m
      m := m+1
  return (y,m,rest+1)
def pad (n width : Nat) : String := String.ofList (List.replicate (width - (toString n).length) '0') ++ toString n
def iso (d : Data) : String := let (y,m,n) := parts d; s!"{pad y 4}-{pad m 2}-{pad n 2}"
def plusYears (d : Data) (n : Int) : Data :=
  let (y,m,day) := parts d
  let yy := (Int.ofNat y+n).toNat
  mkDate yy m (min day (monthDays yy m))
def tStart : Data := mkDate 2015 10 1
def tEnd : Data := mkDate 2026 11 17

inductive W3 where | tak | nie | nieust deriving BEq, DecidableEq, Repr, Inhabited, Hashable
def W3.and : W3 → W3 → W3
  | .nie,_ | _,.nie => .nie
  | .tak,.tak => .tak
  | _,_ => .nieust
def W3.or : W3 → W3 → W3
  | .tak,_ | _,.tak => .tak
  | .nie,.nie => .nie
  | _,_ => .nieust
def W3.not : W3 → W3 | .tak => .nie | .nie => .tak | .nieust => .nieust
def W3.text : W3 → String | .tak => "TAK" | .nie => "NIE" | .nieust => "NIEUSTALONY"
def wb (b : Bool) : W3 := if b then .tak else .nie

/-- Własności funkcji logiki używanych bezpośrednio przez silnik, bez osobnej implementacji. -/
theorem W3.and_comm (a b : W3) : a.and b = b.and a := by cases a <;> cases b <;> rfl
theorem W3.or_comm (a b : W3) : a.or b = b.or a := by cases a <;> cases b <;> rfl
theorem W3.not_not (a : W3) : a.not.not = a := by cases a <;> rfl

structure Chwila where
  lo : Data
  hi : Option Data
  deriving BEq, Repr, Inhabited, Hashable
def exactDate (d : Data) : Chwila := ⟨d,some d⟩
def Chwila.known (c : Chwila) : Bool := c.hi == some c.lo
def Chwila.text (c : Chwila) : String :=
  if c.known then iso c.lo else s!"[{iso c.lo}, {(c.hi.map iso).getD "?"}]"
def Chwila.years (c : Chwila) (n : Int) : Chwila := ⟨plusYears c.lo n,c.hi.map (plusYears · n)⟩
def Chwila.days (c : Chwila) (n : Nat) : Chwila := ⟨c.lo+n,c.hi.map (·+n)⟩
def cmax (a b : Chwila) : Chwila := ⟨max a.lo b.lo, do return max (← a.hi) (← b.hi)⟩
def cmin (a b : Chwila) : Chwila := ⟨min a.lo b.lo,
  match a.hi,b.hi with | none,x | x,none => x | some x,some y => some (min x y)⟩
def before (a b : Chwila) : W3 :=
  if a.hi.any (· < b.lo) then .tak else if b.hi.any (· ≤ a.lo) then .nie else .nieust
def noLater (a b : Chwila) : W3 :=
  if a.hi.any (· ≤ b.lo) then .tak else if b.hi.any (· < a.lo) then .nie else .nieust
structure Przedzial where
  start : Chwila
  stop : Option Chwila := none
  deriving BEq, Repr, Inhabited
def Przedzial.contains (p : Przedzial) (d : Data) : W3 :=
  (noLater p.start (exactDate d)).and ((p.stop.map (before (exactDate d))).getD .tak)
def Przedzial.containsTime (p : Przedzial) (c : Chwila) : W3 :=
  let certainStart := p.start.hi.any (· ≤ c.lo)
  let certainEnd := p.stop.all (fun e => c.hi.any (· < e.lo))
  let possibleStart := c.hi.all (p.start.lo ≤ ·)
  let possibleEnd := p.stop.all (fun e => e.hi.all (c.lo < ·))
  if certainStart && certainEnd then .tak else if possibleStart && possibleEnd then .nieust else .nie
def Przedzial.boundaries (p : Przedzial) : Array Data :=
  #[p.start.lo] ++ p.start.hi.toArray ++ (p.stop.map (fun c => #[c.lo] ++ c.hi.toArray)).getD #[]

structure Row where
  id : String := ""
  typ : String := ""
  day : Data := 0
  person : String := ""
  vacancy : String := ""
  attrs : Array (String × String) := #[]
  sources : Array String := #[]
  certain : Bool := true
  notes : String := ""
  line : Nat := 0
  deriving Repr, Inhabited
def Row.a (w : Row) (k : String) (fallback := "") : String := get w.attrs k fallback
def Row.items (w : Row) (k : String) : Array String :=
  let s := w.a k
  if s == "?" || s.isEmpty then #[] else (s.splitOn "+").toArray.filter (!·.isEmpty)
def Row.time (w : Row) : Chwila :=
  if w.certain then exactDate w.day else
  let lo := (parseDate (w.a "data_od")).toOption.getD w.day
  let hi := if !(w.a "data_do").isEmpty then (parseDate (w.a "data_do")).toOption
            else if !(w.a "data_od").isEmpty then some w.day else none
  ⟨lo,hi⟩
structure Registry where
  rows : Array Row := #[]
  errors : Array String := #[]
  warnings : Array String := #[]
  deriving Repr, Inhabited
def Registry.types (r : Registry) (ts : Array String) : Array Row := r.rows.filter (fun w => ts.contains w.typ)
def Registry.forPerson (r : Registry) (o : String) (ts : Array String) : Array Row :=
  (r.rows.filter (fun w => w.person == o && ts.contains w.typ)).qsort (fun a b => a.day < b.day)
def Registry.election (r : Registry) (o : String) : Option Row := r.rows.find? (fun w => w.typ == "E1" && w.person == o)
def Registry.byId (r : Registry) (id : String) : Option Row := r.rows.find? (·.id == id)

def types : Array (String × String) := #[
  ("SEJM","kadencja Sejmu (D9)"),("E1","wybór"),("E2","ślubowanie"),
  ("E3","odmowa przyjęcia ślubowania lub bezczynność"),("E4","dopuszczenie do funkcji"),
  ("E4-","cofnięcie dopuszczenia"),("E5","udział w orzeczeniu lub inna czynność w funkcji"),
  ("E6a","śmierć"),("E6b","zrzeczenie, stan spoczynku, wygaśnięcie"),
  ("E7","postanowienie Prezydenta o Prezesie, Wiceprezesie lub powierzeniu obowiązków"),
  ("E8","uchwała Zgromadzenia Ogólnego"),("E9","przejęcie kierowania bez E7"),
  ("E10","udokumentowane zaprzestanie funkcji"),("E10P","zakończenie funkcji kierowniczej"),
  ("ORZ","orzeczenie (D6)"),("PUB","zdarzenie publikacyjne O1-O4 (D7)"),
  ("UCHWALA_STATUS","uchwała Sejmu o statusie sędziów (D2, dana, nie wzorzec)"),
  ("OCENA","ocena interpretacyjna (P11)"),("D6_ROK","liczba orzeczeń TK w roku (kompletność D6, K4)")]
def personalTypes : Array String := #["E1","E2","E3","E4","E4-","E5","E6a","E6b","E7","E9","E10","E10P"]

/-- Parser CSV: cytowane przecinki, podwojone cudzysłowy, CRLF i wielowierszowe pola. -/
def csv (s : String) : Except String (Array (Array String)) := Id.run do
  let mut rows := #[]; let mut row := #[]; let mut field := ""
  let mut quoted := false; let mut afterQuote := false
  for c in s.toList do
    if quoted then
      if c == '"' then quoted := false; afterQuote := true
      else field := field.push c
    else if afterQuote && c == '"' then
      field := field.push '"'; quoted := true; afterQuote := false
    else if c == ',' then
      row := row.push field; field := ""; afterQuote := false
    else if c == '\n' then
      rows := rows.push (row.push field); row := #[]; field := ""; afterQuote := false
    else if c == '\r' then pure ()
    else if c == '"' && field.isEmpty && !afterQuote then quoted := true
    else if afterQuote then return .error "CSV: znak po zamknięciu cytowanego pola"
    else field := field.push c
  if quoted then return .error "CSV: niedomknięty cudzysłów"
  if !row.isEmpty || !field.isEmpty || afterQuote then rows := rows.push (row.push field)
  return .ok rows

def attributes (s : String) : Except String (Array (String × String)) := do
  let mut out := #[]
  for p in s.splitOn ";" do
    let p := trim p
    unless p.isEmpty do
      let xs := p.splitOn "="
      unless xs.length ≥ 2 do throw s!"atrybut bez '=': {p}"
      out := put out (trim xs[0]!) (trim ("=".intercalate xs.tail))
  return out

def parseRegistry (s : String) : Except String Registry := do
  let rs ← csv s
  unless rs[0]? == some #["id","typ","data","osoba","wakat","atrybuty","zrodlo","pewnosc","uwagi"] do
    throw "Niepoprawny nagłówek rejestru CSV"
  let mut r : Registry := {}
  for n in [1:rs.size] do
    let ps := rs[n]!
    if ps == #[""] then continue
    if ps.size != 9 then r := {r with errors := r.errors.push s!"wiersz {n+1}: oczekiwano 9 pól"}; continue
    match (do
      let d ← parseDate (trim ps[2]!); let a ← attributes ps[5]!
      unless #["ustalone","nieustalone"].contains (trim ps[7]!) do throw "nieznana pewność"
      return ({
        id := trim ps[0]!, typ := trim ps[1]!, day := d, person := trim ps[3]!,
        vacancy := trim ps[4]!, attrs := a, sources := ((ps[6]!.splitOn ";").map trim).toArray.filter (!·.isEmpty),
        certain := trim ps[7]! == "ustalone", notes := trim ps[8]!, line := n+1} : Row)) with
    | .ok w => r := {r with rows := r.rows.push w}
    | .error e => r := {r with errors := r.errors.push s!"wiersz {n+1}: {e}"}
  return r

def validate (r : Registry) : Registry := Id.run do
  let mut errs := r.errors; let mut warns := r.warnings
  let es := r.types #["E1"]; let elected := es.map (·.person)
  let mut ids : Array String := #[]; let mut people : Array String := #[]
  for w in r.rows do
    if w.id.isEmpty || ids.contains w.id then errs := errs.push s!"{w.id}: identyfikator powtórzony lub pusty"
    ids := ids.push w.id
    if !(types.map (·.1)).contains w.typ then errs := errs.push s!"{w.id}: nieznany typ {w.typ}"
    if w.sources.isEmpty then errs := errs.push s!"{w.id}: brak źródła (P5)"
    for s in w.sources do
      if !#["ELI:","SEJM-GL:","IPO:","API-SEJM:","DOC:","WIKI:"].any (fun p => s.startsWith p) then
        errs := errs.push s!"{w.id}: źródło bez znanego prefiksu"
    if personalTypes.contains w.typ && w.person.isEmpty then errs := errs.push s!"{w.id}: wymagana osoba"
    if !w.person.toList.all (fun c => c.isDigit || ('a' ≤ c && c ≤ 'z') || c == '_') then
      errs := errs.push s!"{w.id}: identyfikator osoby spoza [a-z0-9_]"
    if w.typ != "E1" && !w.vacancy.isEmpty then errs := errs.push s!"{w.id}: wakat tylko dla E1"
    for k in #["poczatek","data_od","data_do","do"] do
      if !(w.a k).isEmpty && w.a k != "?" && (parseDate (w.a k)).toOption.isNone then
        errs := errs.push s!"{w.id}: niepoprawna data w polu {k}"
    for k in #["za","przeciw","wstrz"] do
      if !(w.a k).isEmpty && w.a k != "?" && !(w.a k).toNat?.isSome then
        errs := errs.push s!"{w.id}: niepoprawna liczba w polu {k}"
    if w.typ == "E1" then
      if people.contains w.person then errs := errs.push s!"{w.id}: osoba ma drugi wybór"
      people := people.push w.person
      unless w.vacancy.isEmpty || w.vacancy == "?" do
        for a in w.vacancy.splitOn "|" do
          if !a.startsWith "W." || !elected.contains (a.drop 2).toString || (a.drop 2).toString == w.person then
            errs := errs.push s!"{w.id}: wakat nie wskazuje innej osoby z E1"
    else if personalTypes.contains w.typ && !elected.contains w.person then
      errs := errs.push s!"{w.id}: osoba bez zdarzenia E1"
    if #["ORZ","E8"].contains w.typ then
      for k in #["sklad","obecni","glosujacy","dotyczy_tytulu","przepisy_tytulu"] do
        for o in w.items k do
          if !o.toNat?.isSome && !elected.contains o then errs := errs.push s!"{w.id}: {k}: nieznana osoba {o}"
    if w.typ == "E7" && !(w.a "zo").isEmpty && w.a "zo" != "?" && (r.byId (w.a "zo")).isNone then
      errs := errs.push s!"{w.id}: nieistniejąca uchwała ZO"
    if w.typ == "E2" && !#["wobec_prezydenta","sejm","pisemna"].contains (w.a "forma") then
      errs := errs.push s!"{w.id}: nieznana forma ślubowania"
    if w.typ == "PUB" then
      if !#["O1","O2","O3","O4"].contains (w.a "zdarzenie") then errs := errs.push s!"{w.id}: zdarzenie spoza O1-O4"
      if !(r.types #["ORZ"]).any (fun x => x.a "sprawa" == w.a "sprawa") then errs := errs.push s!"{w.id}: brak orzeczenia"
    if w.typ == "OCENA" then
      for k in #["warunek","wynik","autor","status","uzasadnienie"] do
        if (w.a k).isEmpty then errs := errs.push s!"{w.id}: ocena bez pola {k}"
      if !#["spelniony","naruszony","nieustalony"].contains (w.a "wynik") then errs := errs.push s!"{w.id}: nieznany wynik oceny"
      if !#["robocza","zatwierdzona"].contains (w.a "status") then errs := errs.push s!"{w.id}: nieznany status oceny"
    if w.typ == "D6_ROK" && (!(w.a "rok").toNat?.isSome || !(w.a "liczba").toNat?.isSome) then
      errs := errs.push s!"{w.id}: D6_ROK wymaga liczbowych pól rok i liczba"
    if w.typ == "E8" then
      let mut count := 0
      for p in (w.a "glosy").splitOn "+" do
        if p.contains ':' then
          match (p.splitOn ":")[1]!.toNat? with
          | some n => count := count+n
          | none => errs := errs.push s!"{w.id}: niepoprawna liczba głosów"
      if !(w.items "glosujacy").isEmpty && count > (w.items "glosujacy").size then
        errs := errs.push s!"{w.id}: więcej głosów niż głosujących"
  let terms := r.types #["SEJM"]
  if terms.isEmpty then errs := errs.push "brak kadencji Sejmu (D9)"
  for w in es do
    if !terms.any (fun t => t.day ≤ w.day && ((parseDate (t.a "do")).toOption.all (w.day ≤ ·))) then
      warns := warns.push s!"{w.id}: data wyboru poza znanymi kadencjami Sejmu"
  return {r with errors := errs, warnings := warns}

def parameterNames : Array String := #["z1","z2","z3c","z3q","z3m","z4","z5","z5z","z6","z7","z8","z9","z10","z11","z12","z13","z14"]
def values (p : String) : Array String :=
  if p == "z1" then #["a","b","c","d14","d30","d90"]
  else if p == "z4" then #["a","bR1","bR2"]
  else if p == "z3m" || p == "z5z" || p == "z7" then #["a","b","c"] else #["a","b"]
abbrev Interpretation := Array (String × String)
def iv (i : Interpretation) (p : String) : String := get i p
def deps (m : Nat) : Array String :=
  if m == 4 then #[] else #["z1","z2","z4","z7","z12"] ++
  (if m ≥ 2 then #["z3c","z3q","z3m","z5","z5z","z8"] else #[]) ++
  (if m ≥ 3 then #["z6","z9","z10","z11","z13","z14"] else #[])
def identified (i : Interpretation) : Bool := iv i "z7" == "c" && iv i "z4" == "bR2"
def variants (m : Nat) (base : Interpretation := #[]) : Array Interpretation := Id.run do
  let mut out := #[base]
  for p in deps m do
    if !(iv base p).isEmpty then continue
    out := out.flatMap (fun i => (values p).map (fun v => i.push (p,v)))
  return out.filter (!identified ·)
def variantText (i : Interpretation) : String := join " " (i.map fun (k,v) => s!"{k}={v}")
def totalVariants (m : Nat) : Nat := (deps m).foldl (fun n p => n*(values p).size) 1
def extensionCount : Nat := ((deps 3).filter (!(deps 2).contains ·)).foldl (fun n p => n*(values p).size) 1

structure Assumptions where
  ad1 : Bool := true
  ad2 : Bool := true
  ad3 : Bool := true
  ad4 : Bool := true
  ad5 : Bool := true
  ad6 : Bool := true
  ad7 : Bool := true
  deriving Repr, Inhabited
def assumptionNames : Array String := #["ad1_brak_innych_E6","ad2_ślubowanie_niespornych","ad3_dopuszczenie",
  "ad4_początek_od_wyboru","ad5_odejście_niespornych","ad6_kompletność_E7","ad7_brak_funkcji_po_odmowie"]
def Assumptions.flags (a : Assumptions) : Array Bool := #[a.ad1,a.ad2,a.ad3,a.ad4,a.ad5,a.ad6,a.ad7]
def disable (a : Assumptions) (key : String) : Except String Assumptions := do
  match assumptionNames.findIdx? (· == key) with
  | some 0 => return {a with ad1 := false} | some 1 => return {a with ad2 := false}
  | some 2 => return {a with ad3 := false} | some 3 => return {a with ad4 := false}
  | some 4 => return {a with ad5 := false} | some 5 => return {a with ad6 := false}
  | some 6 => return {a with ad7 := false} | _ => throw s!"Nieznane założenie danych: {key}"

end Konstytucja.TK.Test
