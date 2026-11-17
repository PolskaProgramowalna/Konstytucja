import Konstytucja.TK.Test.Raport

namespace Konstytucja.TK.Test

def csvHeader := "id,typ,data,osoba,wakat,atrybuty,zrodlo,pewnosc,uwagi\n"
def fixture (body : String) : Registry := validate ((parseRegistry
  (csvHeader ++ "S,SEJM,2000-01-01,,,kadencja=1;do=,API-SEJM:test,ustalone,\n" ++ body)).toOption.getD {errors := #["błąd parsowania fixture"]})
def roots (n : Nat) (extra := "") : Registry := fixture (String.join ((List.range n).map fun k =>
  s!"E{k},E1,2009-12-01,p{k},,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/{k},ustalone,\n") ++ extra)
def basicI : Interpretation := #[("z1","a"),("z2","a"),("z4","a"),("z7","c"),("z12","a")]
def zoI : Interpretation := basicI ++ #[("z3c","b"),("z3q","b"),("z3m","b"),("z5","a"),("z5z","c"),("z8","b")]
def fixtureState (r : Registry) (i := basicI) (ad : Assumptions := {}) : State :=
  calculate r i ((alternatives r)[0]?.getD #[]) ad
def changeChoice (s : State) (o : String) (f : Choice → Choice) : State :=
  let cs := s.choices.map fun w => if w.person == o then f w else w
  {s with choices := cs,byPerson := cs.foldl (fun m w => m.insert w.person w) {}}
def uncertainTitle (s : State) (o : String) : State := changeChoice s o fun w => {w with title := w.title.map (fun (p,_) => (p,.nieust))}
def emptyTitle (s : State) (o : String) : State := changeChoice s o fun w => {w with title := #[]}
def zoFixture (same votes : Bool) : Registry × State := Id.run do
  let extra := "Z,E8,2012-01-01,,,obecni=p0+p1+p2+p3+p4;glosujacy=p0+p1+p2+p3+p4" ++
    (if votes then ";glosy=p0:5" else "") ++ ",DOC:test,ustalone,\n"
  let r := roots 10 extra
  let mut s := uncertainTitle (uncertainTitle (fixtureState r zoI) "p8") "p9"
  if same then s := changeChoice s "p9" fun w => {w with place := (s.find "p8").place}
  return (r,s)
def testCases (registry : Registry) : Array (String × Bool) := Id.run do
  let mut ts := #[]
  let add := fun name value => (name,value)
  ts := ts.push (add "kalendarz: 29 lutego" (plusYears (mkDate 2016 2 29) 9 == mkDate 2025 2 28))
  ts := ts.push (add "kalendarz: pełny cykl gregoriański" ((List.range 146097).all fun n =>
    let d := mkDate 1800 1 1+n; let (y,m,day) := parts d; mkDate y m day == d))
  ts := ts.push (add "parser odrzuca 1900-02-29" ((parseDate "1900-02-29").toOption.isNone))
  ts := ts.push (add "CSV: cytowanie, przecinek i nowa linia" ((csv "a,\"b,c\",\"d\"\"e\nq\"\r\n").toOption == some #[#["a","b,c","d\"e\nq"]]))
  ts := ts.push (add "CSV: niedomknięty cudzysłów" ((csv "a,\"b").toOption.isNone))
  let p : Przedzial := ⟨exactDate (mkDate 2015 11 6),some (exactDate (mkDate 2024 11 6))⟩
  ts := ts.push (add "przedział półotwarty" (p.contains (mkDate 2015 11 6) == .tak && p.contains (mkDate 2024 11 6) == .nie))
  ts := ts.push (add "niepewny koniec" ((Przedzial.contains ⟨exactDate (mkDate 2016 1 1),some ⟨mkDate 2017 1 1,none⟩⟩ (mkDate 2018 1 1)) == .nieust))
  ts := ts.push (add "logika trójwartościowa" ((W3.tak.and .nieust) == .nieust && (W3.nie.and .nieust) == .nie && (W3.tak.or .nieust) == .tak && W3.nieust.not == .nieust))
  ts := ts.push (add "rejestr bez błędów" registry.errors.isEmpty)
  let bad := fixture "A,E1,2010-01-01,x,,poczatek=2010-01-10,ELI:MP/1,ustalone,\nA,E2,2010-01-02,x,,forma=wobec_prezydenta,,ustalone,\nB,E4,2010-01-03,missing,,,DOC:x,ustalone,\nC,E1,2011-01-01,y,W.zzz,,ELI:MP/2,pewne,\n"
  ts := ts.push (add "walidator: błędne ID, źródła i odwołania" (bad.errors.size ≥ 4))
  let bad := fixture "A,E1,2010-01-01,x,,poczatek=2010-02-30;za=abc,DOC:x,ustalone,\n"
  ts := ts.push (add "walidator: daty i liczby w atrybutach" (bad.errors.size ≥ 2))
  ts := ts.push (add "nieznany wynik wyboru pozostaje nieustalony" (electionProcedure basicI {attrs := #[("za","?")]} == .nieust))
  ts := ts.push (add "warianty: 216/192/27648/1769472" (totalVariants 1 == 216 && (variants 1).size == 192 && (variants 2).size == 27648 && (variants 2).size*64 == 1769472))
  let first := (variants 1)[0]!
  ts := ts.push (add "złączenie: jedna wartość wspólnego parametru" ((variants 2 first).all fun i => (deps 1).all (fun p => iv i p == iv first p)))
  ts := ts.push (add "F1 nie filtruje naruszeń" ((variants 1).all (!identified ·) && (variants 1).any (fun i => iv i "z7" == "a" && iv i "z1" == "b")))
  let alts := alternatives registry
  ts := ts.push (add "alternatywy rejestru: 4" (alts.size == 4))
  for z in #["a","b","c"] do
    let s := calculate registry (put basicI "z7" z) alts[0]!
    let reason := fun o => (((s.find o).reasons.find? (·.1 == "wyprzedzający")).map (·.2)).getD .nieust
    ts := ts.push (add s!"H1: Z7{z}" (reason "hauser" == (if z == "a" then .tak else .nie) && reason "sitek" == (if z == "c" then .nie else .tak) && reason "sokala" == (if z == "c" then .nie else .tak)))
  let s := calculate registry basicI alts[0]!
  ts := ts.push (add "konwencja dat pozostaje jawna" ((s.find "hauser").free.map (·.lo) == some (mkDate 2015 11 6) && (s.find "sitek").free.map (·.lo) == some (mkDate 2015 12 2)))
  let t10 := fixture "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\nB,E2,2010-01-10,x,,forma=wobec_prezydenta,DOC:x,ustalone,\nC,E5,2019-01-15,x,,,DOC:x,ustalone,\nD,UCHWALA_STATUS,2018-01-01,,,dotyczy=x,DOC:x,ustalone,\n"
  let c := (fixtureState t10).find "x"
  ts := ts.push (add "T10: tytuł wygasa" (c.titleAt (mkDate 2019 1 9) == .tak && c.titleAt (mkDate 2019 1 10) == .nie))
  ts := ts.push (add "T10: potwierdzenie i niepewność po E5" (c.activeAt (mkDate 2019 1 12) == .nieust && c.activeAt (mkDate 2019 1 15) == .tak && c.activeAt (mkDate 2019 1 16) == .nieust && c.activeAt (mkDate 2026 11 16) == .nieust))
  let stop := fixture "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\nB,E10,2019-02-01,x,,,DOC:x,ustalone,\nD,UCHWALA_STATUS,2018-01-01,,,dotyczy=x,DOC:x,ustalone,\n"
  let c := (fixtureState stop).find "x"
  ts := ts.push (add "E10 kończy funkcję" (c.activeAt (mkDate 2019 2 1) == .nie && c.activeAt (mkDate 2019 1 20) == .nieust))
  let r := roots 9
  let s := uncertainTitle (uncertainTitle (fixtureState r) "p7") "p8"
  let us := (completions s ((List.range 9).toArray.map (fun n => s!"p{n}")) (mkDate 2012 1 1)).getD #[]
  let qs := us.map fun u => decide (((#["p0","p1","p2","p3","p7"].filter (hasTitle u)).size*2) > (u.filter (·.2)).size)
  ts := ts.push (add "P10: kontrprzykład kworum 4/8" (qs.contains true && qs.contains false && aggregate qs == unknown))
  let (r1,s1) := zoFixture true true; let (r2,s2) := zoFixture false true
  let zo1 := (r1.byId "Z").getD {}; let zo2 := (r2.byId "Z").getD {}
  let (a,cache) := evaluateZO s1 zoI zo1 #[] {} "p0"
  let (b,_) := evaluateZO s2 zoI zo2 #[] cache "p0"
  ts := ts.push (add "TKI-1: pamięć ZO uwzględnia korelacje" (a.result == fulfilled && b.result == unknown))
  let (r,s) := zoFixture true false
  ts := ts.push (add "TKI-2: brak głosów nie dowodzi naruszenia" ((evaluateZO s zoI ((r.byId "Z").getD {}) #[] {} "p0").1.result == unknown))
  let r := roots 2 "Z,E8,2012-01-01,,,obecni=p0+p1;glosujacy=p0+p1;glosy=p0:3,DOC:x,ustalone,\n"
  ts := ts.push (add "walidator: nadmiar głosów ZO" (!r.errors.isEmpty))
  let p : Przedzial := ⟨exactDate (mkDate 2016 1 10),some (exactDate (mkDate 2016 1 20))⟩
  let ch : Chwila := ⟨mkDate 2016 1 1,some (mkDate 2016 1 31)⟩
  ts := ts.push (add "TKI-3: całe zakresy dat" (p.containsTime ch == .nieust && occupied #[("x",p.start,p.stop,.tak)] ch == .nieust && p.containsTime ⟨mkDate 2016 1 11,some (mkDate 2016 1 12)⟩ == .tak && p.containsTime ⟨mkDate 2016 2 1,none⟩ == .nie))
  let r := fixture "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\nC,E5,2019-01-15,x,,,DOC:x,ustalone,\n"
  let s := fixtureState r basicI {ad2 := false,ad3 := false,ad5 := false}
  ts := ts.push (add "TKI-4: E5 bez E4 zachowuje niepewność" ((s.find "x").activeAt (mkDate 2019 1 15) == .tak && (s.find "x").activeAt (mkDate 2019 1 16) == .nieust))
  let r := fixture "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\nB,E3,2010-01-10,x,,,DOC:x,ustalone,\n"
  let enabled := fixtureState r
  let disabled := fixtureState r basicI {ad7 := false}
  ts := ts.push (add "AD7: odmowa nie oznacza braku funkcji po wyłączeniu założenia" ((enabled.find "x").activeAt (mkDate 2012 1 1) == .nie && (disabled.find "x").activeAt (mkDate 2012 1 1) == .nieust))
  let r := fixture "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\nB,E4,2010-01-01,x,,,DOC:x,ustalone,\nC,E4-,2011-01-01,x,,,DOC:x,ustalone,\nD,E4,2012-01-01,x,,,DOC:x,ustalone,\n"
  let c := (fixtureState r).find "x"
  ts := ts.push (add "TKI-5: ponowne dopuszczenie" (c.activeAt (mkDate 2010 6 1) == .tak && c.activeAt (mkDate 2011 6 1) == .nie && c.activeAt (mkDate 2012 1 2) == .tak))
  let pubBase := "X,E1,2009-12-01,x,,poczatek=2010-01-10,ELI:MP/1,ustalone,\nR,ORZ,2016-01-10,,,sprawa=K 1/16;art188=tak;sklad=x;wynik=jednoglosnie,IPO:K 1/16,ustalone,\n"
  let r := fixture (pubBase ++ "O,OCENA,2016-02-01,,,warunek=W6b:K 1/16;wynik=nieustalony;autor=recenzent;status=zatwierdzona;uzasadnienie=brak danych,DOC:x,ustalone,\n")
  ts := ts.push (add "TKI-6: zatwierdzone nieustalenie" (r.errors.isEmpty && (step8 r)[0]!.result == unknown))
  let r := fixture (pubBase ++ "O,OCENA,2016-02-01,,,warunek=W6b:K 1/16;wynik=zle;autor=a;status=zatwierdzona;uzasadnienie=u,DOC:x,ustalone,\n")
  ts := ts.push (add "walidator: nieznana ocena" (!r.errors.isEmpty))
  let s := emptyTitle (emptyTitle (fixtureState (roots 3)) "p1") "p2"
  ts := ts.push (add "TKI-7: Z13b nie pomija kworum" (z13Unanimous #["p0","p1","p2"] s (mkDate 2012 1 1) #[("z11","a")] == unknown && z13Unanimous #["p0","p1","p2"] s (mkDate 2012 1 1) #[("z11","b")] == uncovered && z13Unanimous #["p1","p2"] s (mkDate 2012 1 1) #[("z11","a")] == "WADLIWE"))
  let pubs := step8 registry
  let p := (pubs.find? (fun p => p.row.a "sprawa" == "K 47/15")).getD {}
  ts := ts.push (add "R-PUB: 818 dni to wskaźnik, nie ocena" (p.elapsed == 818 && p.result == unknown))
  let r := fixture (pubBase ++ "P,PUB,2016-01-20,,,sprawa=K 1/16;zdarzenie=O2;organ=prm,DOC:x,ustalone,\nQ,PUB,2016-05-01,,,sprawa=K 1/16;zdarzenie=O3;organ=prm,ELI:DU/1,ustalone,\n")
  ts := ts.push (add "R-PUB: odmowa wykonana" ((step8 r)[0]!.result == violated && (step8 r)[0]!.violationStart == some (mkDate 2016 1 20)))
  ts := ts.push (add "K4: granice udziału" (defectiveShare 1 0 1 none 10 == .nieust && defectiveShare 3 0 4 (some 4) 50 == .tak && defectiveShare 0 0 4 (some 4) 10 == .nie && defectiveShare 0 0 4 (some 10) 50 == .nieust))
  let badLeader : Leader := ⟨"a","prezes",mkDate 2018 3 1,some (mkDate 2019 1 1),violated,#[]⟩
  let okLeader : Leader := ⟨"a","prezes",mkDate 2010 1 1,none,fulfilled,#[]⟩
  ts := ts.push (add "K4: kierownictwo w roku" (leadershipInYear #[badLeader] 2018 == .tak && leadershipInYear #[okLeader] 2018 == .nie && leadershipInYear #[{okLeader with start := mkDate 2018 3 1}] 2018 == .nieust))
  let st := calculate registry basicI alts[0]! {ad1 := false}
  ts := ts.push (add "wyłączenie AD1 daje nieustalenie" ((st.find "kieres").titleAt (mkDate 2016 1 1) == .nieust))
  let i := zoI ++ #[("z6","a"),("z9","b"),("z10","a"),("z11","a"),("z13","b"),("z14","a")]
  let st := calculate registry i alts[0]!
  let ks := (step6 registry st i).1
  let ds := step7 registry st i ks
  let find := fun name => (ds.find? (fun d => d.row.a "sprawa" == name)).getD {}
  ts := ts.push (add "większość z wyniku, nie zdań odrębnych" ((find "K 1/17").detected[2]! == unknown && (find "U 5/24").detected[2]! == "NIE"))
  ts := ts.push (add "Z13b bez głosów nieustalony" ((find "K 2/25").effects[0]! == unknown))
  ts := ts.push (add "Z10: konflikt osobisty" ((find "K 1/17").detected[4]! == "TAK" && (find "Kp 3/24").detected[4]! == "NIE"))
  let ds2 := step7 registry st (put i "z10" "b") ks
  ts := ts.push (add "Z10b: przepisy o tytule" (((ds2.find? (fun d => d.row.a "sprawa" == "Kp 3/24")).getD {}).detected[4]! == "TAK"))
  let result := run registry {} (some 2)
  ts := ts.push (add "przebieg techniczny: złączenie i agregacja" (result.counts == #[2*alts.size,2*alts.size*144,2*alts.size*144*64] && result.aggregates.contains "orzeczenie:K 1/17" && result.partialRun))
  ts := ts.push (add "raport próby nie deklaruje pełnego przeglądu" (((report registry result "test").splitOn "NIEPEŁNY PRZEGLĄD").length == 2))
  return ts

end Konstytucja.TK.Test
