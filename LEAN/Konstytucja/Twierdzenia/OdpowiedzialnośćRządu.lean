import Konstytucja.Procedury.OdpowiedzialnośćRządu
import Konstytucja.Twierdzenia.TworzenieRządu

/-! # Własności odpowiedzialności rządu

Grupy wyników: osiągalność, ograniczenia, blokady, rozstrzyganie spraw w toku,
trwałość rządu oraz złożenie z art. 154–155.
-/

namespace Konstytucja.OdpowiedzialnośćRządu

open Konstytucja

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

private theorem okno (t : Nat) : wOknieGłosowania Z t (t + 7) := wLimicieCzasu_refl _ _

private def pusty : Głosowanie .sejm := ⟨0, 0, 0, by decide⟩
private def pełny : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩

private theorem pusty_bez_nieufności : ¬ wotumNieufności pusty := by
  simp [wotumNieufności, większośćUstawowa, pusty, Izba.ustawowaLiczba]

private theorem pełny_nieufność : wotumNieufności pełny := by
  simp [wotumNieufności, większośćUstawowa, pełny, Izba.ustawowaLiczba]

private theorem pusty_bez_ministra : ¬ wotumNieufnościMinistra pusty := by
  simp [wotumNieufnościMinistra, większośćUstawowa, pusty, Izba.ustawowaLiczba]

private theorem pełny_minister : wotumNieufnościMinistra pełny := by
  simp [wotumNieufnościMinistra, większośćUstawowa, pełny, Izba.ustawowaLiczba]

private theorem pusty_bez_zaufania : ¬ wotumZaufaniaArt160 pusty := by
  simp [wotumZaufaniaArt160, kworum, pusty, Głosowanie.głosujący, Izba.ustawowaLiczba]

private theorem pełny_zaufanie : wotumZaufaniaArt160 pełny := by
  simp [wotumZaufaniaArt160, kworum, większośćZwykła, pełny, Głosowanie.głosujący,
    Izba.ustawowaLiczba]

/-- Art. 158 ust. 2 zd. 3: 115 posłów pomija limit 3 miesięcy. -/
private theorem próg_115 {o t} : powtórnyDopuszczalny Z o 115 115 t := Or.inl (Nat.le_refl _)

/-! ## Osiągalność -/

theorem wotum_daje_nowy_rząd (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .nowyRząd 0 := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z)) (.zgłoszenieNieufności 115 0 (by decide) próg_115)
  have b := Osiągalny.krok a (.wotumUchwalone pełny s pełny_nieufność (okno 0))
  exact ⟨_, .krok b (.powołanieWybranego p (refl _)), rfl⟩

theorem brak_wotum_daje_dymisję (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .dymisjaPrzyjęta := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z)) .wniosekZaufania
  have b := Osiągalny.krok a (.zaufanieNieudzielone pusty s pusty_bez_zaufania (refl 0))
  exact ⟨_, .krok b (.przyjęcieDymisji p (refl _)), rfl⟩

theorem nowy_sejm_daje_dymisję (p : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .dymisjaPrzyjęta :=
  ⟨_, .krok (.krok .start .pierwszePosiedzenie) (.przyjęcieDymisji p (refl _)), rfl⟩

theorem rezygnacja_daje_dymisję (p : Z.prezydentDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .dymisjaPrzyjęta :=
  ⟨_, .krok (.krok .start .rezygnacja) (.przyjęcieDymisji p (refl _)), rfl⟩

/-- Art. 162 ust. 4: złożona rezygnacja może nie zostać przyjęta i rząd urzęduje dalej. -/
theorem rezygnacja_odmowa (p : Z.prezydentDziała = true) :
    ∃ v u, Osiągalny Z v ∧ v.etap = .dymisjaZłożona .rezygnacja ∧
      Krok Z v u ∧ u.etap = .urzęduje :=
  ⟨_, _, .krok .start .rezygnacja, rfl, .odmowaPrzyjęcia p (refl 0), rfl⟩

/-- Art. 159 ust. 2: po obaleniu ministra Prezydent go odwołuje. Etap odwołania jest osiągalny. -/
theorem minister_odwołany (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true) :
    ∃ v u, Osiągalny Z v ∧ v.etap = .odwołanieMinistra ∧ Krok Z v u ∧ u.etap = .urzęduje := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z)) (.zgłoszenieMinistra 69 (by decide) (Or.inr trivial))
  exact ⟨_, _, .krok a (.ministerObalony pełny s pełny_minister (okno 0)), rfl,
    .odwołanie p (refl _), rfl⟩

/-- Art. 160: po wniosku Sejm udziela wotum, a rząd urzęduje dalej bez dymisji. -/
theorem wotum_zaufania_udzielone (s : Z.sejmDziała = true) :
    ∃ v u, Osiągalny Z v ∧ v.etap = .wniosekZaufania ∧ Krok Z v u ∧ u.etap = .urzęduje :=
  ⟨_, _, .krok .start .wniosekZaufania, rfl, .zaufanieUdzielone pełny s pełny_zaufanie (refl 0),
    rfl⟩

/-! ## Ograniczenia -/

/-- Art. 158 ust. 2 zd. 1: głosowanie najwcześniej 7 dni po zgłoszeniu. -/
theorem głosowanie_po_7_dniach {t a b o s}
    {w} (k : Krok Z ⟨.wniosekNieufności w, t, a, b, o⟩ s) : t + 7 ≤ s.dzień := by
  cases k <;> simp_all [wOknieGłosowania, wLimicieCzasu]

/-- Art. 159 ust. 1 w związku z art. 158 ust. 2. -/
theorem głosowanie_ministra_po_7_dniach {t a b o s}
    (k : Krok Z ⟨.wniosekMinistra, t, a, b, o⟩ s) : t + 7 ≤ s.dzień := by
  cases k <;> simp_all [wOknieGłosowania, wLimicieCzasu]

/-- Art. 158 ust. 2 zd. 2: po odczekaniu 3 miesięcy osiągalny jest wniosek 46 posłów. -/
theorem powtórny_wniosek_46_osiągalny (s : Z.sejmDziała = true) :
    ∃ v, Osiągalny Z v ∧ v.etap = .wniosekNieufności 0 ∧ v.odrzucone = 1 := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z))
    (.zgłoszenieNieufności 46 0 (by decide) (Or.inr trivial))
  have b := Osiągalny.krok a (.wotumNieuchwalone pusty s pusty_bez_nieufności (okno 0))
  have c := Osiągalny.krok b (.upływCzasu (t' := max (0 + 7) (Z.kalendarz.poMiesiącach 0 3))
    (by omega))
  exact ⟨_, .krok c (.zgłoszenieNieufności 46 0 (by decide) (Or.inr (by
    show Z.kalendarz.poMiesiącach 0 3 ≤ _
    omega))), rfl, rfl⟩

/-- Art. 158 ust. 2 zd. 2: powtórny wniosek mniej niż 115 posłów dopiero po 3 miesiącach. -/
theorem powtórny_po_3_miesiącach {z n t} (d : powtórnyDopuszczalny Z (some z) 115 n t)
    (m : n < 115) : Z.kalendarz.poMiesiącach z 3 ≤ t := by
  cases d with
  | inl h => omega
  | inr h => exact h

/-- Art. 158 ust. 1: 45 posłów nie wystarcza. -/
theorem wniosek_wymaga_46 {t a b o s w}
    (k : Krok Z ⟨.urzęduje, t, a, b, o⟩ s) (e : s.etap = .wniosekNieufności w) :
    ∃ n, n ≥ 46 ∧ powtórnyDopuszczalny Z a 115 n t := by
  cases k with
  | zgłoszenieNieufności n _ m d => exact ⟨n, m, d⟩
  | upływCzasu => cases e
  | zgłoszenieMinistra => cases e
  | wniosekZaufania => cases e
  | pierwszePosiedzenie => cases e
  | rezygnacja => cases e

/-- Art. 158 ust. 1: uchwalone wotum dotyczy kandydata wskazanego we wniosku. -/
theorem wotum_przenosi_kandydata {t a b o s w}
    (k : Krok Z ⟨.wniosekNieufności w, t, a, b, o⟩ s) :
    s.etap = .powołanieWybranego w ∨ s.etap = .urzęduje := by
  cases k <;> simp

/-- Art. 158 ust. 1 i art. 162 ust. 4: po wotum nie ma odmowy, a Prezydent powołuje
kandydata wskazanego we wniosku, a nie innego. -/
theorem po_wotum_tylko_powołanie {t a b o s w}
    (k : Krok Z ⟨.powołanieWybranego w, t, a, b, o⟩ s) : s.etap = .nowyRząd w := by
  cases k; rfl

/-- Art. 162 ust. 4: odmowa możliwa tylko przy rezygnacji. -/
theorem odmowa_tylko_przy_rezygnacji {t a b o p s}
    (k : Krok Z ⟨.dymisjaZłożona p, t, a, b, o⟩ s) (e : s.etap = .urzęduje) :
    p = .rezygnacja := by
  cases k with
  | przyjęcieDymisji => cases e
  | odmowaPrzyjęcia => rfl

/-- Niezmiennik: dni ostatnich wniosków nie leżą w przyszłości. -/
def historiaWPrzeszłości (s : Stan) : Prop :=
  (∀ z, s.ostatniRząd = some z → z ≤ s.dzień) ∧
    (∀ z, s.ostatniMinister = some z → z ≤ s.dzień)

theorem historia_poprawna {s} (h : Osiągalny Z s) : historiaWPrzeszłości s := by
  induction h with
  | start => simp [historiaWPrzeszłości]
  | krok _ k ih =>
    obtain ⟨i₁, i₂⟩ := ih
    constructor <;> cases k <;>
      simp only [wLimicie, wOknieGłosowania, wLimicieCzasu] at * <;>
      intro z e <;>
      first
        | (have := i₁ z e; omega)
        | (have := i₂ z e; omega)
        | (cases e; omega)

/-- Żaden krok nie cofa czasu. -/
theorem czas_nie_cofa {a b} (k : Krok Z a b) : a.dzień ≤ b.dzień := by
  cases k <;> simp_all [wLimicie, wOknieGłosowania, wLimicieCzasu] <;> omega

/-! ## Blokady -/

/-- Art. 158 ust. 1 nie podaje terminu powołania ani skutku bezczynności. -/
theorem bezczynność_blokuje_powołanie (s : Z.sejmDziała = true)
    (p : Z.prezydentDziała = false) :
    ∃ v, Osiągalny Z v ∧ v.etap = .powołanieWybranego 0 ∧ ∀ u, ¬ Krok Z v u := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z)) (.zgłoszenieNieufności 115 0 (by decide) próg_115)
  refine ⟨_, .krok a (.wotumUchwalone pełny s pełny_nieufność (okno 0)), rfl, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 159 ust. 2 też nie przewiduje skutku bezczynności. -/
theorem bezczynność_blokuje_odwołanie (s : Z.sejmDziała = true)
    (p : Z.prezydentDziała = false) :
    ∃ v, Osiągalny Z v ∧ v.etap = .odwołanieMinistra ∧ ∀ u, ¬ Krok Z v u := by
  have a := Osiągalny.krok (Osiągalny.start (Z := Z)) (.zgłoszenieMinistra 69 (by decide) (Or.inr trivial))
  refine ⟨_, .krok a (.ministerObalony pełny s pełny_minister (okno 0)), rfl, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 162 ust. 3 nie przewiduje skutku nieprzyjęcia dymisji. -/
theorem bezczynność_blokuje_przyjęcie_dymisji (p : Z.prezydentDziała = false) :
    ∃ v, Osiągalny Z v ∧ v.etap = .dymisjaZłożona .nowySejm ∧ ∀ u, ¬ Krok Z v u := by
  refine ⟨_, .krok .start .pierwszePosiedzenie, rfl, fun u k => ?_⟩
  cases k <;> simp_all

/-! ## Rozstrzyganie spraw w toku -/

/-- Krok rozstrzygający: wyjście z etapu, który czeka na decyzję. -/
def Rozstrzygnięcie (Z : Założenia) (a b : Stan) : Prop :=
  Krok Z a b ∧ a.etap.ustalony = false

theorem krok_rozstrzyga {a b} (k : Rozstrzygnięcie Z a b) : b.etap.ranga < a.etap.ranga := by
  obtain ⟨k, u⟩ := k
  cases k <;> simp_all [Etap.ranga, Etap.ustalony]

/-- Sprawy w toku nie mogą ciągnąć się bez końca. -/
theorem brak_nieskończonego_rozstrzygania (f : Nat → Stan) :
    ¬ ∀ n, Rozstrzygnięcie Z (f n) (f (n + 1)) :=
  brak_nieskończonego (fun s => s.etap.ranga) krok_rozstrzyga f

structure WarunkiRozstrzygnięcia (Z : Założenia) : Prop where
  sejm : Z.sejmDziała = true
  prezydent : Z.prezydentDziała = true

theorem postęp_rozstrzygania (w : WarunkiRozstrzygnięcia Z) (s : Stan)
    (n : s.etap.ustalony = false) : ∃ u, Rozstrzygnięcie Z s u := by
  obtain ⟨e, t, a, b, o⟩ := s
  have hs := w.sejm
  have hp := w.prezydent
  cases e with
  | wniosekNieufności k =>
    exact ⟨_, .wotumNieuchwalone pusty hs pusty_bez_nieufności (okno t), n⟩
  | powołanieWybranego k => exact ⟨_, .powołanieWybranego hp (refl t), n⟩
  | wniosekMinistra => exact ⟨_, .ministerUtrzymany pusty hs pusty_bez_ministra (okno t), n⟩
  | odwołanieMinistra => exact ⟨_, .odwołanie hp (refl t), n⟩
  | wniosekZaufania => exact ⟨_, .zaufanieUdzielone pełny hs pełny_zaufanie (refl t), n⟩
  | dymisjaZłożona p => exact ⟨_, .przyjęcieDymisji hp (refl t), n⟩
  | urzęduje | dymisjaPrzyjęta | nowyRząd _ => simp [Etap.ustalony] at n

/-- Przy działaniu organów każda sprawa w toku prowadzi do stanu ustalonego. -/
theorem rozstrzygnięcie_spraw (w : WarunkiRozstrzygnięcia Z) (s : Stan) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.ustalony = true := by
  obtain ⟨u, p, k⟩ := dojście_do_końca (fun s => s.etap.ranga)
    (fun s => s.etap.ustalony = true) krok_rozstrzyga
    (fun s n => postęp_rozstrzygania w s (by simpa using n)) s
  exact ⟨u, Przebieg.przenieś id (fun r => r.1) p, k⟩

/-! ## Trwałość rządu -/

/-- Rząd nie musi się zmienić: nieudane wnioski mogą się powtarzać bez ograniczenia liczby. -/
theorem dowolnie_wiele_nieudanych_wniosków (s : Z.sejmDziała = true) (n : Nat) :
    ∃ u, Osiągalny Z u ∧ u.etap = .urzęduje ∧ u.odrzucone = n := by
  induction n with
  | zero => exact ⟨_, .start, rfl, rfl⟩
  | succ n ih =>
    obtain ⟨⟨e, t, a, b, o⟩, h, ee, eo⟩ := ih
    simp only at ee eo
    subst ee eo
    have c := Osiągalny.krok h (.zgłoszenieNieufności 115 0 (by decide) próg_115)
    exact ⟨_, .krok c (.wotumNieuchwalone pusty s pusty_bez_nieufności (okno t)), rfl, rfl⟩

/-! ## Złożenie z art. 154–155 -/

variable {R : TworzenieRządu.Założenia}

/-- Art. 154 ust. 1: po przyjęciu dymisji, przy warunkach art. 154–155, prowadzi przebieg
do nowego rządu albo skrócenia kadencji. -/
theorem dymisja_prowadzi_do_wyniku (w : TworzenieRządu.WarunkiZakończenia R) (t a b o) :
    ∃ u, Przebieg (PełnyKrok Z R) (.inl ⟨.dymisjaPrzyjęta, t, a, b, o⟩) (.inr u) ∧
      (u.etap = .rząd ∨ u.etap = .kadencjaSkrócona) := by
  obtain ⟨u, p, k⟩ := TworzenieRządu.zakończenie w ⟨.powołanie154, t⟩
  exact ⟨u, .dalej .poDymisji
    (Przebieg.przenieś (Sum.inr) (fun r => .tworzenie r) p), k⟩

/-- Pełny obieg: rząd upada przez brak wotum zaufania, powstaje nowy, który obejmuje urząd.
Teza przechodzi przez stan automatu art. 154–155, więc nie jest pustym przebiegiem.
Stan końcowy pojedynczego automatu nie jest końcem ustroju. -/
theorem pełny_obieg (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true)
    (r : R.prezydentDziała = true) (t a b o) :
    Przebieg (PełnyKrok Z R) (.inl ⟨.urzęduje, t, a, b, o⟩) (.inr ⟨.rząd, t⟩) ∧
      PełnyKrok Z R (.inr ⟨.rząd, t⟩) (.inl ⟨.urzęduje, t, none, none, 0⟩) := by
  refine ⟨?_, .objęcieUrzędu⟩
  refine .dalej (.odpowiedzialność .wniosekZaufania) ?_
  refine .dalej (.odpowiedzialność
    (.zaufanieNieudzielone (t' := t) pusty s pusty_bez_zaufania (refl t))) ?_
  refine .dalej (.odpowiedzialność (.przyjęcieDymisji (t' := t) p (refl t))) ?_
  refine .dalej .poDymisji ?_
  refine .dalej (.tworzenie (.powołanie (t' := t) r (by simp [wCiągu]))) ?_
  exact .dalej (.tworzenie (.wotumTak (t' := t) (by simp [wCiągu]))) (.stój _)

end Konstytucja.OdpowiedzialnośćRządu
