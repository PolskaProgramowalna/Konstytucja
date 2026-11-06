import Konstytucja.Procedury.Ustawodawstwo

/-! # Własności postępowania ustawodawczego

Grupy wyników: osiągalność, ograniczenia, powroty i brak górnej granicy, blokady
oraz zakończenie i granica czasu przy jawnych założeniach.
-/

namespace Konstytucja.Ustawodawstwo

open Konstytucja

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

private theorem wCiągu_refl (t n : Nat) : wCiągu t n t := by simp [wCiągu]

/-! ## Pomocnicze głosowania -/

private def pusty : Głosowanie .sejm := ⟨0, 0, 0, by decide⟩
private def pełny : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩

private theorem pusty_bez_kworum : ¬ kworum pusty := by
  simp [kworum, pusty, Głosowanie.głosujący, Izba.ustawowaLiczba]

private theorem pełny_ustawa : uchwalenieUstawy pełny := by
  simp [uchwalenieUstawy, kworum, większośćZwykła, pełny, Głosowanie.głosujący,
    Izba.ustawowaLiczba]

private theorem pełny_stanowisko (m) : odrzucenieStanowiskaSenatu m pełny := by
  cases m <;>
    simp [odrzucenieStanowiskaSenatu, kworum, większośćBezwzględna, pełny,
      Głosowanie.głosujący, Głosowanie.mianownik, Izba.ustawowaLiczba]

private theorem pełny_weto (m) : odrzucenieWeta m pełny := by
  cases m <;>
    simp [odrzucenieWeta, kworum, większośćUłamkowa, pełny, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba]

/-! ## Osiągalność -/

theorem do_marszałka (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.marszałek, 0, 0, false, 0⟩ :=
  .krok (.krok .start (.uchwalenie pełny s pełny_ustawa (refl 0)))
    (.senatPrzyjmuje (wCiągu_refl 0 _))

theorem do_prezydenta (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.prezydent, 0, terminPodpisu Z, false, 0⟩ :=
  .krok (do_marszałka s) (.przedstawienie s (refl 0))

theorem do_trybunału (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.trybunał, 0, terminPodpisu Z, true, 0⟩ :=
  .krok (do_prezydenta s) (.wniosekDoTrybunału (d := 0) h (Nat.zero_le _))

theorem podpisana_osiągalna (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana :=
  ⟨_, .krok (do_prezydenta s) (.podpis (d := 0) h (Nat.zero_le _)), rfl⟩

theorem podpisana_częściowo_osiągalna (s : Z.sejmDziała = true)
    (h : Z.prezydentDziała = true) (t : Z.trybunałOrzeka = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisanaCzęściowo :=
  ⟨_, .krok (.krok (do_trybunału s h) (.orzeczenieCzęściowa t (refl 0)))
    (.podpisZPominięciem (d := 0) h (Nat.zero_le _)), rfl⟩

theorem upadła_przez_nieuchwalenie (s : Z.sejmDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok .start (.nieuchwalenie pusty s (fun h => pusty_bez_kworum h.1) (refl 0)), rfl⟩

theorem upadła_przez_stanowisko_senatu (s : Z.sejmDziała = true)
    (q : Z.sejmRozpatruje = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok (.krok (.krok .start (.uchwalenie pełny s pełny_ustawa (refl 0)))
    (.senatOdrzuca (wCiągu_refl 0 _)))
    (.odrzucenieUtrzymane pusty q (fun h => pusty_bez_kworum h.1) (refl 0)), rfl⟩

theorem upadła_przez_trybunał (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true)
    (t : Z.trybunałOrzeka = true) : ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok (do_trybunału s h) (.orzeczenieNiezgodna t (refl 0)), rfl⟩

theorem wycofana_osiągalna : ∃ u, Osiągalny Z u ∧ u.etap = .wycofana :=
  ⟨_, .krok .start (.wycofanie (refl 0)), rfl⟩

theorem podpisana_po_wecie (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana :=
  ⟨_, .krok (.krok (.krok (do_prezydenta s) (.weto (d := 0) h (Nat.zero_le _)))
    (.ponowneUchwalenie pełny s (pełny_weto _) (refl 0)))
    (.podpisPoWecie (d := 0) h (Nat.zero_le _)), rfl⟩

theorem upadła_przez_weto (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok (.krok (do_prezydenta s) (.weto (d := 0) h (Nat.zero_le _)))
    (.wetoUtrzymane pusty s (fun h => pusty_bez_kworum h.1) (refl 0)), rfl⟩

/-! ## Ograniczenia -/

theorem terminSenatu_le (Z : Założenia) : terminSenatu Z ≤ 30 := by
  simp only [terminSenatu]
  split <;> omega

theorem terminPodpisu_le (Z : Założenia) : terminPodpisu Z ≤ 21 := by
  simp only [terminPodpisu]
  split <;> omega

/-- Art. 123 ust. 3. -/
theorem terminy_pilne (h : Z.pilny = true) : terminSenatu Z = 14 ∧ terminPodpisu Z = 7 := by
  simp [terminSenatu, terminPodpisu, h]

/-- Art. 123 ust. 1: projekt podatkowy nigdy nie jest pilny. -/
theorem podatkowy_nie_pilny (h : Z.rodzaj = .podatkowy) : Z.pilny = false := by
  cases p : Z.pilny with
  | false => rfl
  | true =>
    have := Z.pilnośćDopuszczalna p
    simp [h, RodzajProjektu.możePilny] at this

/-- Na podpis zostaje najwyżej 21 dni, niezależnie od liczby wstrzymań i powrotów. -/
theorem zegar_ograniczony {s} (h : Osiągalny Z s) : s.pozostało ≤ 21 := by
  induction h with
  | start => simp
  | krok _ k ih =>
    have := terminPodpisu_le Z
    cases k <;> simp only at * <;> omega

/-- Art. 122 ust. 6: czas Trybunału nie zużywa terminu podpisania. -/
theorem trybunał_wstrzymuje_termin {t r w p s}
    (k : Krok Z ⟨.trybunał, t, r, w, p⟩ s) : s.pozostało = r := by
  cases k <;> rfl

/-- Art. 122 ust. 5: weto tylko bez wcześniejszego wniosku do Trybunału. -/
theorem weto_tylko_bez_wniosku {t r w p s}
    (k : Krok Z ⟨.prezydent, t, r, w, p⟩ s) (e : s.etap = .sejmPoWecie) : w = false := by
  cases k with
  | weto => rfl
  | podpis => cases e
  | wniosekDoTrybunału => cases e

/-- Art. 122 ust. 3 zd. 2: po orzeczeniu zgodności Prezydent może tylko podpisać. -/
theorem po_zgodności_tylko_podpis {t r w p s}
    (k : Krok Z ⟨.podpisPoTrybunale, t, r, w, p⟩ s) : s.etap = .podpisana := by
  cases k; rfl

/-- Art. 122 ust. 5 zd. 3: po ponownym uchwaleniu nie ma wniosku do Trybunału. -/
theorem po_wecie_tylko_podpis {t r w p s}
    (k : Krok Z ⟨.prezydentPoWecie, t, r, w, p⟩ s) : s.etap = .podpisana := by
  cases k; rfl

/-- Art. 121 ust. 3: poprawki Senatu nie mogą zakończyć postępowania. -/
theorem poprawki_nie_kończą {t r w p s}
    (k : Krok Z ⟨.sejmPoPoprawkach, t, r, w, p⟩ s) : s.etap = .marszałek := by
  cases k; rfl

/-- Art. 119 ust. 4: wycofać projekt można tylko w Sejmie. -/
theorem wycofanie_tylko_w_sejmie {a b} (k : Krok Z a b) (e : b.etap = .wycofana) :
    a.etap = .sejm := by
  cases k <;> first | rfl | cases e

/-- Art. 121 ust. 2 zd. 2: bierność Senatu nie blokuje postępowania. -/
theorem senat_nie_blokuje (t r w p) : ∃ s, Krok Z ⟨.senat, t, r, w, p⟩ s :=
  ⟨_, .senatMilczy⟩

/-! ## Powroty i brak górnej granicy -/

/-- Jedna runda: Trybunał, częściowa niezgodność, zwrot i ponowne przedstawienie. -/
theorem runda (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true)
    (t : Z.trybunałOrzeka = true) (m : Z.maksPowrotów = none) {d r w p}
    (o : Osiągalny Z ⟨.prezydent, d, r, w, p⟩) :
    Osiągalny Z ⟨.prezydent, d, terminPodpisu Z, true, p + 1⟩ := by
  have a := Osiągalny.krok o (.wniosekDoTrybunału (d := 0) h (Nat.zero_le _))
  have b := Osiągalny.krok a (.orzeczenieCzęściowa t (refl _))
  have c := Osiągalny.krok b
    (.zwrot (d := 0) h (Nat.zero_le _) (by simp [możnaZwrócić, m]))
  cases n : Z.powrótPrzezSenat with
  | false =>
    exact .krok (.krok c (.usunięcie s (refl _) n)) (.przedstawienie s (refl _))
  | true =>
    have e := Osiągalny.krok c (.usunięcieZSenatem s (refl _) n)
    have f := Osiągalny.krok e (.senatPrzyjmuje (wCiągu_refl _ _))
    exact .krok f (.przedstawienie s (refl _))

/-- Tekst nie ogranicza liczby zwrotów, więc bez założenia U7 obecna miara nie działa:
ta sama ustawa może wracać dowolnie wiele razy. -/
theorem dowolnie_wiele_powrotów (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true)
    (t : Z.trybunałOrzeka = true) (m : Z.maksPowrotów = none) (n : Nat) :
    ∃ u, Osiągalny Z u ∧ u.etap = .prezydent ∧ u.powroty = n := by
  induction n with
  | zero => exact ⟨_, do_prezydenta s, rfl, rfl⟩
  | succ n ih =>
    obtain ⟨⟨e, d, r, w, p⟩, o, ee, ep⟩ := ih
    simp only at ee ep
    subst ee ep
    exact ⟨_, runda s h t m o, rfl, rfl⟩

/-- L12: art. 122 nie podaje terminu Trybunałowi, więc bez U6 podpis może nastąpić
dowolnie późno, choć terminu podpisania nie przekroczono. -/
theorem brak_górnej_granicy (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true)
    (t : Z.trybunałOrzeka = true) (l : Z.limit = none) (n : Nat) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana ∧ u.dzień > n := by
  have a : wLimicie Z 0 (n + 1) := by simp [wLimicie, wLimicieCzasu, l]
  have b := Osiągalny.krok (do_trybunału s h) (.orzeczenieZgodna t a)
  exact ⟨_, .krok b (.podpisPoZgodności (d := 0) h (Nat.zero_le _)), rfl, by simp⟩

/-! ## Blokady -/

/-- Bez orzeczenia Trybunału automat staje w osiągalnym stanie niekońcowym. -/
theorem brak_orzeczenia_blokuje (s : Z.sejmDziała = true) (h : Z.prezydentDziała = true)
    (t : Z.trybunałOrzeka = false) :
    Osiągalny Z ⟨.trybunał, 0, terminPodpisu Z, true, 0⟩ ∧
      ∀ u, ¬ Krok Z ⟨.trybunał, 0, terminPodpisu Z, true, 0⟩ u := by
  refine ⟨do_trybunału s h, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 122 ust. 2 nie przewiduje skutku niepodpisania: automat staje. -/
theorem bezczynność_prezydenta_blokuje (s : Z.sejmDziała = true)
    (h : Z.prezydentDziała = false) :
    Osiągalny Z ⟨.prezydent, 0, terminPodpisu Z, false, 0⟩ ∧
      ∀ u, ¬ Krok Z ⟨.prezydent, 0, terminPodpisu Z, false, 0⟩ u := by
  refine ⟨do_prezydenta s, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 121 ust. 3 nie podaje terminu Sejmowi: po poprawkach automat staje. -/
theorem bierność_sejmu_blokuje (s : Z.sejmDziała = true) (b : Z.sejmRozpatruje = false) :
    Osiągalny Z ⟨.sejmPoPoprawkach, 0, 0, false, 0⟩ ∧
      ∀ u, ¬ Krok Z ⟨.sejmPoPoprawkach, 0, 0, false, 0⟩ u := by
  refine ⟨.krok (.krok .start (.uchwalenie pełny s pełny_ustawa (refl 0)))
    (.senatPoprawia (wCiągu_refl 0 _)), fun u k => ?_⟩
  cases k <;> simp_all

/-! ## Zakończenie przy założeniu U7 -/

/-- Miara: zapas zwrotów jest ważniejszy niż etap. -/
def miara (m : Nat) (s : Stan) : Nat := (m - s.powroty) * 15 + s.etap.ranga

theorem krok_zmniejsza {m} (l : Z.maksPowrotów = some m) {a b} (k : Krok Z a b) :
    miara m b < miara m a := by
  cases k <;> simp only [miara, Etap.ranga, możnaZwrócić, l] at * <;> omega

/-- Przy założeniu U7 nie ma nieskończonego przebiegu. -/
theorem brak_nieskończonego_przy_limicie {m} (l : Z.maksPowrotów = some m) (f : Nat → Stan) :
    ¬ ∀ n, Krok Z (f n) (f (n + 1)) :=
  brak_nieskończonego (miara m) (krok_zmniejsza l) f

structure WarunkiZakończenia (Z : Założenia) : Prop where
  sejm : Z.sejmDziała = true
  rozpatruje : Z.sejmRozpatruje = true
  prezydent : Z.prezydentDziała = true
  trybunał : Z.trybunałOrzeka = true

theorem postęp (w : WarunkiZakończenia Z) (s : Stan) (n : s.etap.końcowy = false) :
    ∃ u, Krok Z s u := by
  obtain ⟨e, t, r, x, p⟩ := s
  have hs := w.sejm
  have hp := w.prezydent
  have ht := w.trybunał
  cases e with
  | sejm => exact ⟨_, .wycofanie (refl t)⟩
  | senat => exact ⟨_, .senatMilczy⟩
  | sejmPoPoprawkach => exact ⟨_, .poprawkiRozpatrzone w.rozpatruje (refl t)⟩
  | sejmPoOdrzuceniu =>
    exact ⟨_, .odrzucenieUtrzymane pusty w.rozpatruje
      (fun h => pusty_bez_kworum h.1) (refl t)⟩
  | marszałek => exact ⟨_, .przedstawienie hs (refl t)⟩
  | prezydent => exact ⟨_, .podpis (d := 0) hp (Nat.zero_le _)⟩
  | trybunał => exact ⟨_, .orzeczenieZgodna ht (refl t)⟩
  | podpisPoTrybunale => exact ⟨_, .podpisPoZgodności (d := 0) hp (Nat.zero_le _)⟩
  | wybórPoTrybunale => exact ⟨_, .podpisZPominięciem (d := 0) hp (Nat.zero_le _)⟩
  | sejmUsuwa =>
    cases q : Z.powrótPrzezSenat with
    | false => exact ⟨_, .usunięcie hs (refl t) q⟩
    | true => exact ⟨_, .usunięcieZSenatem hs (refl t) q⟩
  | sejmPoWecie =>
    exact ⟨_, .wetoUtrzymane pusty hs (fun h => pusty_bez_kworum h.1) (refl t)⟩
  | prezydentPoWecie => exact ⟨_, .podpisPoWecie (d := 0) hp (Nat.zero_le _)⟩
  | podpisana | podpisanaCzęściowo | upadła | wycofana => simp [Etap.końcowy] at n

/-- Przy działaniu organów i założeniu U7 z każdego stanu prowadzi przebieg do wyniku. -/
theorem zakończenie (w : WarunkiZakończenia Z) {m} (l : Z.maksPowrotów = some m) (s : Stan) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.końcowy = true :=
  dojście_do_końca (miara m) (fun s => s.etap.końcowy = true) (krok_zmniejsza l)
    (fun s n => postęp w s (by simpa using n)) s

/-- Teza `zakończenie` zależy od `s`: ze stanu końcowego nie ma dokąd przejść. -/
theorem brak_kroku_ze_stanu_końcowego {s u} (k : s.etap.końcowy = true) :
    ¬ Krok Z s u := by
  intro h
  obtain ⟨e, t, r, x, p⟩ := s
  cases h <;> simp [Etap.końcowy] at k

/-! ## Granica czasu przy założeniach U6 i U7 -/

/-- Górna granica czasu `p + 1` rund. -/
def budżet (L p : Nat) : Nat := (4 * L + 58) * (p + 1)

theorem budżet_nast (L p : Nat) : budżet L (p + 1) = budżet L p + (4 * L + 58) := by
  simp only [budżet, Nat.mul_add, Nat.add_mul]
  omega

/-- Definicja pomocnicza: ile czasu może jeszcze zająć bieżąca runda. -/
def potencjał (L : Nat) (s : Stan) : Nat :=
  match s.etap with
  | .sejm | .sejmUsuwa => 4 * L + 58
  | .senat => 3 * L + 58
  | .sejmPoPoprawkach | .sejmPoOdrzuceniu => 3 * L + 28
  | .marszałek => 2 * L + 28
  | .prezydent => s.pozostało + L + 7
  | .trybunał => L + s.pozostało
  | .sejmPoWecie => L + 7
  | .podpisPoTrybunale | .wybórPoTrybunale | .prezydentPoWecie => s.pozostało
  | .podpisana | .podpisanaCzęściowo | .upadła | .wycofana => 0

theorem inwariant_czasu {L s} (l : Z.limit = some L) (h : Osiągalny Z s) :
    s.dzień + potencjał L s ≤ budżet L s.powroty := by
  induction h with
  | start => simp [potencjał, budżet]
  | krok _ k ih =>
    have a := terminSenatu_le Z
    have b := terminPodpisu_le Z
    cases k <;>
      simp only [potencjał, wLimicie, wLimicieCzasu, wCiągu, budżet_nast, l] at * <;> omega

theorem powroty_w_limicie {m s} (l : Z.maksPowrotów = some m) (h : Osiągalny Z s) :
    s.powroty ≤ m := by
  induction h with
  | start => simp
  | krok _ k ih =>
    cases k <;> simp only [możnaZwrócić, l] at * <;> omega

/-- Przy limicie `L` dla czynności bez terminu i `m` zwrotach cała procedura jest ograniczona. -/
theorem granica_przy_limitach {L m s} (l : Z.limit = some L) (r : Z.maksPowrotów = some m)
    (h : Osiągalny Z s) : s.dzień ≤ budżet L m := by
  have a := inwariant_czasu l h
  have b := powroty_w_limicie r h
  have c : budżet L s.powroty ≤ budżet L m :=
    Nat.mul_le_mul_left _ (by omega)
  omega

end Konstytucja.Ustawodawstwo
