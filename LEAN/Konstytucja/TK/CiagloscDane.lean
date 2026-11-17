-- PLIK GENEROWANY przez `python3 tk_test.py lean` - nie edytować ręcznie.
-- Źródło: dane/tk_rejestr.csv, SHA-256 f719f49f2e215c8ed24ac966b25d2098b87b94644f5665a58e1fb200e1236e91
import Konstytucja.TK.Ciaglosc

/-! # Rejestr zdarzeń testu ciągłości TK (dane, plan_tk.txt pkt 6 i 12)

Kontrola F2 w Lean: identyfikatory zdarzeń są unikalne, a każde zdarzenie osobowe
odnosi się do osoby, która ma wybór (E1). Daty: dni od 1970-01-01.
-/

namespace Konstytucja.TK.CiagloscDane

set_option maxRecDepth 20000

inductive Typ where
  /-- SEJM: kadencja Sejmu (D9) -/
  | t0
  /-- E1: wybór -/
  | t1
  /-- E2: ślubowanie -/
  | t2
  /-- E3: odmowa przyjęcia ślubowania lub bezczynność -/
  | t3
  /-- E4: dopuszczenie do funkcji -/
  | t4
  /-- E4-: cofnięcie dopuszczenia -/
  | t5
  /-- E5: udział w orzeczeniu lub inna czynność w funkcji -/
  | t6
  /-- E6a: śmierć -/
  | t7
  /-- E6b: zrzeczenie, stan spoczynku, wygaśnięcie -/
  | t8
  /-- E7: postanowienie Prezydenta o Prezesie, Wiceprezesie lub powierzeniu obowiązków -/
  | t9
  /-- E8: uchwała Zgromadzenia Ogólnego -/
  | t10
  /-- E9: przejęcie kierowania bez E7 -/
  | t11
  /-- E10: udokumentowane zaprzestanie funkcji -/
  | t12
  /-- E10P: zakończenie funkcji kierowniczej -/
  | t13
  /-- ORZ: orzeczenie (D6) -/
  | t14
  /-- PUB: zdarzenie publikacyjne O1-O4 (D7) -/
  | t15
  /-- UCHWALA_STATUS: uchwała Sejmu o statusie sędziów (D2, dana, nie wzorzec) -/
  | t16
  /-- OCENA: ocena interpretacyjna (P11) -/
  | t17
  /-- D6_ROK: liczba orzeczeń TK w roku (kompletność D6, K4) -/
  | t18
  deriving DecidableEq, Repr

structure Zdarzenie where
  nr : Nat
  typ : Typ
  dzień : Nat
  osoba : Nat
  deriving DecidableEq, Repr

-- 0: (brak osoby)
-- 1: baginska
-- 2: bentkowska
-- 3: berek
-- 4: biernat
-- 5: cieslak
-- 6: cioch
-- 7: dziurda
-- 8: gintowt
-- 9: granat
-- 10: hauser
-- 11: hermelinski
-- 12: jakubecki
-- 13: jedrejek
-- 14: jedrzejewski
-- 15: kieres
-- 16: korwin
-- 17: kotlinowski
-- 18: liszcz
-- 19: markiewicz
-- 20: morawski
-- 21: muszynski
-- 22: patyra
-- 23: pawlowicz
-- 24: piotrowicz
-- 25: piskorski
-- 26: przylebska
-- 27: pszczolkowski
-- 28: pyziak
-- 29: rymar
-- 30: rzeplinski
-- 31: sitek
-- 32: slebzak
-- 33: sochanski
-- 34: sokala
-- 35: stelina
-- 36: swieczkowski
-- 37: sych
-- 38: szostek
-- 39: taborowski
-- 40: tuleja
-- 41: warcinski
-- 42: wojciechowski
-- 43: wrobel
-- 44: wronkowska
-- 45: wyrembak
-- 46: zielonacki
-- 47: zubik

def rejestr : List Zdarzenie := [
  ⟨0, .t0, 13075, 0⟩,  -- S5 SEJM 2005-10-19 
  ⟨1, .t0, 13822, 0⟩,  -- S6 SEJM 2007-11-05 
  ⟨2, .t0, 15286, 0⟩,  -- S7 SEJM 2011-11-08 
  ⟨3, .t0, 16751, 0⟩,  -- S8 SEJM 2015-11-12 
  ⟨4, .t0, 18212, 0⟩,  -- S9 SEJM 2019-11-12 
  ⟨5, .t0, 19674, 0⟩,  -- S10 SEJM 2023-11-13 
  ⟨6, .t1, 13448, 8⟩,  -- W01 E1 2006-10-27 gintowt
  ⟨7, .t1, 13448, 11⟩,  -- W02 E1 2006-10-27 hermelinski
  ⟨8, .t1, 13448, 17⟩,  -- W03 E1 2006-10-27 kotlinowski
  ⟨9, .t1, 13469, 5⟩,  -- W04 E1 2006-11-17 cieslak
  ⟨10, .t1, 13490, 1⟩,  -- W05 E1 2006-12-08 baginska
  ⟨11, .t1, 13490, 18⟩,  -- W06 E1 2006-12-08 liszcz
  ⟨12, .t1, 13630, 9⟩,  -- W07 E1 2007-04-27 granat
  ⟨13, .t1, 13865, 30⟩,  -- W08 E1 2007-12-18 rzeplinski
  ⟨14, .t1, 14043, 4⟩,  -- W09 E1 2008-06-13 biernat
  ⟨15, .t1, 14735, 44⟩,  -- W10 E1 2010-05-06 wronkowska
  ⟨16, .t1, 14939, 29⟩,  -- W11 E1 2010-11-26 rymar
  ⟨17, .t1, 14939, 40⟩,  -- W12 E1 2010-11-26 tuleja
  ⟨18, .t1, 14939, 47⟩,  -- W13 E1 2010-11-26 zubik
  ⟨19, .t1, 14979, 28⟩,  -- W14 E1 2011-01-05 pyziak
  ⟨20, .t1, 15121, 43⟩,  -- W15 E1 2011-05-27 wrobel
  ⟨21, .t1, 15534, 15⟩,  -- W16 E1 2012-07-13 kieres
  ⟨22, .t1, 16716, 10⟩,  -- W17 E1 2015-10-08 hauser
  ⟨23, .t1, 16716, 32⟩,  -- W18 E1 2015-10-08 slebzak
  ⟨24, .t1, 16716, 12⟩,  -- W19 E1 2015-10-08 jakubecki
  ⟨25, .t1, 16716, 31⟩,  -- W20 E1 2015-10-08 sitek
  ⟨26, .t1, 16716, 34⟩,  -- W21 E1 2015-10-08 sokala
  ⟨27, .t1, 16771, 6⟩,  -- W22 E1 2015-12-02 cioch
  ⟨28, .t1, 16771, 20⟩,  -- W23 E1 2015-12-02 morawski
  ⟨29, .t1, 16771, 21⟩,  -- W24 E1 2015-12-02 muszynski
  ⟨30, .t1, 16771, 26⟩,  -- W25 E1 2015-12-02 przylebska
  ⟨31, .t1, 16771, 27⟩,  -- W26 E1 2015-12-02 pszczolkowski
  ⟨32, .t1, 16905, 14⟩,  -- W27 E1 2016-04-14 jedrzejewski
  ⟨33, .t1, 17150, 41⟩,  -- W28 E1 2016-12-15 warcinski
  ⟨34, .t1, 17221, 13⟩,  -- W29 E1 2017-02-24 jedrejek
  ⟨35, .t1, 17325, 46⟩,  -- W30 E1 2017-06-08 zielonacki
  ⟨36, .t1, 17424, 25⟩,  -- W31 E1 2017-09-15 piskorski
  ⟨37, .t1, 17557, 45⟩,  -- W32 E1 2018-01-26 wyrembak
  ⟨38, .t1, 18012, 37⟩,  -- W33 E1 2019-04-26 sych
  ⟨39, .t1, 18221, 23⟩,  -- W34 E1 2019-11-21 pawlowicz
  ⟨40, .t1, 18221, 24⟩,  -- W35 E1 2019-11-21 piotrowicz
  ⟨41, .t1, 18221, 35⟩,  -- W36 E1 2019-11-21 stelina
  ⟨42, .t1, 18250, 42⟩,  -- W37 E1 2019-12-20 wojciechowski
  ⟨43, .t1, 18358, 33⟩,  -- W38 E1 2020-04-06 sochanski
  ⟨44, .t1, 19031, 36⟩,  -- W39 E1 2022-02-08 swieczkowski
  ⟨45, .t1, 20525, 2⟩,  -- W40 E1 2026-03-13 bentkowska
  ⟨46, .t1, 20525, 7⟩,  -- W41 E1 2026-03-13 dziurda
  ⟨47, .t1, 20525, 16⟩,  -- W42 E1 2026-03-13 korwin
  ⟨48, .t1, 20525, 19⟩,  -- W43 E1 2026-03-13 markiewicz
  ⟨49, .t1, 20525, 38⟩,  -- W44 E1 2026-03-13 szostek
  ⟨50, .t1, 20525, 39⟩,  -- W45 E1 2026-03-13 taborowski
  ⟨51, .t1, 20615, 22⟩,  -- W46 E1 2026-06-11 patyra
  ⟨52, .t1, 20700, 3⟩,  -- W47 E1 2026-09-04 berek
  ⟨53, .t16, 16764, 0⟩,  -- U01 UCHWALA_STATUS 2015-11-25 
  ⟨54, .t16, 19788, 0⟩,  -- U02 UCHWALA_STATUS 2024-03-06 
  ⟨55, .t16, 20525, 0⟩,  -- U03 UCHWALA_STATUS 2026-03-13 
  ⟨56, .t2, 16772, 6⟩,  -- P01 E2 2015-12-03 cioch
  ⟨57, .t2, 16772, 20⟩,  -- P02 E2 2015-12-03 morawski
  ⟨58, .t2, 16772, 21⟩,  -- P03 E2 2015-12-03 muszynski
  ⟨59, .t2, 16772, 27⟩,  -- P04 E2 2015-12-03 pszczolkowski
  ⟨60, .t2, 16778, 26⟩,  -- P05 E2 2015-12-09 przylebska
  ⟨61, .t3, 16772, 10⟩,  -- P06 E3 2015-12-03 hauser
  ⟨62, .t3, 16772, 12⟩,  -- P07 E3 2015-12-03 jakubecki
  ⟨63, .t3, 16772, 32⟩,  -- P08 E3 2015-12-03 slebzak
  ⟨64, .t3, 16772, 31⟩,  -- P09 E3 2015-12-03 sitek
  ⟨65, .t3, 16772, 34⟩,  -- P10 E3 2015-12-03 sokala
  ⟨66, .t2, 20544, 2⟩,  -- P11 E2 2026-04-01 bentkowska
  ⟨67, .t2, 20544, 38⟩,  -- P12 E2 2026-04-01 szostek
  ⟨68, .t2, 20552, 7⟩,  -- P13 E2 2026-04-09 dziurda
  ⟨69, .t2, 20552, 16⟩,  -- P14 E2 2026-04-09 korwin
  ⟨70, .t2, 20552, 19⟩,  -- P15 E2 2026-04-09 markiewicz
  ⟨71, .t2, 20552, 39⟩,  -- P16 E2 2026-04-09 taborowski
  ⟨72, .t3, 20544, 7⟩,  -- P17 E3 2026-04-01 dziurda
  ⟨73, .t3, 20544, 16⟩,  -- P18 E3 2026-04-01 korwin
  ⟨74, .t3, 20544, 19⟩,  -- P19 E3 2026-04-01 markiewicz
  ⟨75, .t3, 20544, 39⟩,  -- P20 E3 2026-04-01 taborowski
  ⟨76, .t2, 20662, 22⟩,  -- P21 E2 2026-07-28 patyra
  ⟨77, .t2, 20740, 3⟩,  -- P22 E2 2026-10-14 berek
  ⟨78, .t3, 20740, 3⟩,  -- P23 E3 2026-10-14 berek
  ⟨79, .t4, 16812, 26⟩,  -- D01 E4 2016-01-12 przylebska
  ⟨80, .t4, 16812, 27⟩,  -- D02 E4 2016-01-12 pszczolkowski
  ⟨81, .t4, 17155, 6⟩,  -- D03 E4 2016-12-20 cioch
  ⟨82, .t4, 17155, 20⟩,  -- D04 E4 2016-12-20 morawski
  ⟨83, .t4, 17155, 21⟩,  -- D05 E4 2016-12-20 muszynski
  ⟨84, .t4, 20552, 2⟩,  -- D06 E4 2026-04-09 bentkowska
  ⟨85, .t4, 20552, 38⟩,  -- D07 E4 2026-04-09 szostek
  ⟨86, .t4, 20756, 16⟩,  -- D08 E4 2026-10-30 korwin
  ⟨87, .t7, 17359, 20⟩,  -- K01 E6a 2017-07-12 morawski
  ⟨88, .t7, 17520, 6⟩,  -- K02 E6a 2017-12-20 cioch
  ⟨89, .t8, 17154, 43⟩,  -- K03 E6b 2016-12-19 wrobel
  ⟨90, .t8, 20427, 23⟩,  -- K04 E6b 2025-12-05 pawlowicz
  ⟨91, .t6, 17463, 21⟩,  -- O01 E5 2017-10-24 muszynski
  ⟨92, .t6, 17463, 14⟩,  -- O02 E5 2017-10-24 jedrzejewski
  ⟨93, .t6, 17463, 6⟩,  -- O03 E5 2017-10-24 cioch
  ⟨94, .t6, 17463, 15⟩,  -- O04 E5 2017-10-24 kieres
  ⟨95, .t6, 17463, 46⟩,  -- O05 E5 2017-10-24 zielonacki
  ⟨96, .t9, 17155, 26⟩,  -- L01 E7 2016-12-20 przylebska
  ⟨97, .t9, 17156, 26⟩,  -- L02 E7 2016-12-21 przylebska
  ⟨98, .t9, 17352, 21⟩,  -- L03 E7 2017-07-05 muszynski
  ⟨99, .t9, 20067, 36⟩,  -- L04 E7 2024-12-10 swieczkowski
  ⟨100, .t11, 20756, 16⟩,  -- L05 E9 2026-10-30 korwin
  ⟨101, .t13, 20056, 26⟩,  -- L06 E10P 2024-11-29 przylebska
  ⟨102, .t13, 20756, 36⟩,  -- L07 E10P 2026-10-30 swieczkowski
  ⟨103, .t10, 17135, 0⟩,  -- Z01 E8 2016-11-30 
  ⟨104, .t10, 17155, 0⟩,  -- Z02 E8 2016-12-20 
  ⟨105, .t10, 20066, 0⟩,  -- Z03 E8 2024-12-09 
  ⟨106, .t10, 20767, 0⟩,  -- Z04 E8 2026-11-10 
  ⟨107, .t14, 16772, 0⟩,  -- R01 ORZ 2015-12-03 
  ⟨108, .t14, 16778, 0⟩,  -- R02 ORZ 2015-12-09 
  ⟨109, .t14, 16869, 0⟩,  -- R03 ORZ 2016-03-09 
  ⟨110, .t14, 17024, 0⟩,  -- R04 ORZ 2016-08-11 
  ⟨111, .t14, 17112, 0⟩,  -- R05 ORZ 2016-11-07 
  ⟨112, .t14, 17463, 0⟩,  -- R06 ORZ 2017-10-24 
  ⟨113, .t14, 19871, 0⟩,  -- R07 ORZ 2024-05-28 
  ⟨114, .t14, 20214, 0⟩,  -- R08 ORZ 2025-05-06 
  ⟨115, .t14, 20298, 0⟩,  -- R09 ORZ 2025-07-29 
  ⟨116, .t14, 20585, 0⟩,  -- R10 ORZ 2026-05-12 
  ⟨117, .t15, 16779, 0⟩,  -- B01 PUB 2015-12-10 
  ⟨118, .t15, 16785, 0⟩,  -- B02 PUB 2015-12-16 
  ⟨119, .t15, 16787, 0⟩,  -- B03 PUB 2015-12-18 
  ⟨120, .t15, 16869, 0⟩,  -- B04 PUB 2016-03-09 
  ⟨121, .t15, 17687, 0⟩,  -- B05 PUB 2018-06-05 
  ⟨122, .t15, 17023, 0⟩,  -- B06 PUB 2016-08-10 
  ⟨123, .t15, 17687, 0⟩,  -- B07 PUB 2018-06-05 
  ⟨124, .t15, 17687, 0⟩,  -- B08 PUB 2018-06-05 
  ⟨125, .t15, 17466, 0⟩,  -- B09 PUB 2017-10-27 
  ⟨126, .t12, 20060, 21⟩,  -- F01 E10 2024-12-03 muszynski
  ⟨127, .t12, 20060, 27⟩,  -- F02 E10 2024-12-03 pszczolkowski
  ⟨128, .t12, 20066, 26⟩,  -- F03 E10 2024-12-09 przylebska
  ⟨129, .t12, 20206, 14⟩,  -- F04 E10 2025-04-28 jedrzejewski
  ⟨130, .t12, 20442, 41⟩,  -- F05 E10 2025-12-20 warcinski
  ⟨131, .t12, 20427, 23⟩,  -- F06 E10 2025-12-05 pawlowicz
  ⟨132, .t12, 20632, 46⟩,  -- F07 E10 2026-06-28 zielonacki
  ⟨133, .t12, 20714, 25⟩,  -- F08 E10 2026-09-18 piskorski
  ⟨134, .t9, 14946, 30⟩,  -- L08 E7 2010-12-03 rzeplinski
  ⟨135, .t9, 14946, 4⟩  -- L09 E7 2010-12-03 biernat
]

/-- Liczba zdarzeń w rejestrze. -/
theorem liczba_zdarzeń : rejestr.length = 136 := by decide

/-- F2: identyfikatory zdarzeń są unikalne. -/
theorem identyfikatory_unikalne : (rejestr.map (·.nr)).Nodup :=
  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)

/-- Osoby, które mają zdarzenie E1. -/
def wybrani : List Nat := (rejestr.filter (·.typ == .t1)).map (·.osoba)

/-- F2: każda osoba ma co najwyżej jeden wybór (brak podwójnego zaliczenia). -/
theorem jeden_wybór : wybrani.Nodup :=
  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)

/-- F2: każde zdarzenie osobowe odnosi się do osoby z wyborem. -/
theorem osoby_mają_wybór : rejestr.all (fun z => z.osoba == 0 || wybrani.contains z.osoba) = true := by
  decide

end Konstytucja.TK.CiagloscDane
