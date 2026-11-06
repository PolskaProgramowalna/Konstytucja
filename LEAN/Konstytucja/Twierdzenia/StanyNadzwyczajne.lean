import Konstytucja.Procedury.StanyNadzwyczajne

/-! # Własności stanów nadzwyczajnych -/

namespace Konstytucja.StanyNadzwyczajne

open Konstytucja

variable {Z : Założenia}

private def pusty : Głosowanie .sejm := ⟨0, 0, 0, by decide⟩
private def pełny : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩

private theorem pełny_zgoda : zgodaSejmu pełny := by
  simp [zgodaSejmu, kworum, większośćZwykła, pełny, Głosowanie.głosujący, Izba.ustawowaLiczba]

private theorem pełny_uchyla : uchylenie Z pełny := by
  cases m : Z.mianownik <;>
    simp [uchylenie, kworum, większośćBezwzględna, pełny, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba, m]

private theorem w48 (K : Kalendarz) (t : Nat) : wTerminie K t (.godziny 48) t := by
  simp [wTerminie, koniecTerminu]

/-! ## Osiągalność -/

theorem do_decyzji (r : Rodzaj) (n : r ≠ .klęskaŻywiołowa) (w : przesłankiSpełnione Z r) :
    Osiągalny Z ⟨.decyzjaPrezydenta r, 0, 0⟩ :=
  .krok .start (.wniosek r n w)

theorem do_trwania_wyjątkowego (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.trwa .wyjątkowy 0 (some (0 + godziny 90)) 0, 0, 0⟩ :=
  .krok (.krok (.krok (do_decyzji .wyjątkowy (by decide) w)
    (.wprowadzenieWyjątkowego p (Nat.le_refl _)))
    (.przedstawienie p (w48 _ 0) (Nat.le_refl _)))
    (.utrzymanie s (Nat.le_refl _) (Nat.le_add_right _ _))

theorem wojenny_osiągalny (w : przesłankiSpełnione Z .wojenny) (p : Z.prezydentDziała = true)
    (s : Z.sejmDziała = true) : Osiągalny Z ⟨.trwa .wojenny 0 none 0, 0, 0⟩ :=
  .krok (.krok (.krok (do_decyzji .wojenny (by decide) w) (.wprowadzenieWojennego p))
    (.przedstawienie p (w48 _ 0) (Nat.le_refl _)))
    (.utrzymanie s (Nat.le_refl _) (Nat.le_add_right _ _))

theorem klęska_osiągalna (w : przesłankiSpełnione Z .klęskaŻywiołowa) :
    Osiągalny Z ⟨.trwa .klęskaŻywiołowa 0 (some (0 + godziny 30)) 0, 0, 0⟩ :=
  .krok .start (.wprowadzenieKlęski w (Nat.le_refl _))

theorem uchylenie_osiągalne (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .poStanie .wojenny 0 0 :=
  ⟨_, .krok (.krok (.krok (do_decyzji .wojenny (by decide) w) (.wprowadzenieWojennego p))
    (.przedstawienie p (w48 _ 0) (Nat.le_refl _)))
    (.uchylenie pełny s pełny_uchyla (Nat.le_refl _) (Nat.le_add_right _ _)), rfl⟩

theorem odmowa_prezydenta_osiągalna (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) : Osiągalny Z ⟨.normalny, 0, 0⟩ :=
  .krok (do_decyzji .wyjątkowy (by decide) w) (.odmowa p)

/-! ## Ograniczenia -/

/-- Art. 229–230: Prezydent działa tylko na wniosek Rady Ministrów i przy przesłankach. -/
theorem decyzja_wymaga_przesłanek {a b r} (k : Krok Z a b)
    (e : b.etap = .decyzjaPrezydenta r) : przesłankiSpełnione Z r := by
  cases k with
  | wniosek _ _ h => cases e; exact h
  | _ => cases e

/-- Art. 232: stan klęski nie idzie przez Prezydenta. -/
theorem klęska_bez_prezydenta {a b} (k : Krok Z a b) :
    b.etap ≠ .decyzjaPrezydenta .klęskaŻywiołowa := by
  intro e
  cases k with
  | wniosek _ n _ => cases e; exact n rfl
  | _ => cases e

/-- Art. 231: przedstawienie Sejmowi w ciągu 48 godzin od podpisania. -/
theorem przedstawienie_w_48_godzin {r p k t x s}
    (h : Krok Z ⟨.podpisane r p k, t, x⟩ s) : s.chwila ≤ p + 48 := by
  cases h with
  | przedstawienie _ w _ => exact w.2

/-- Niezmiennik limitów: stan z terminem nie przekracza swoich granic. -/
def wGranicach (s : Stan) : Prop :=
  (∀ p k, s.etap = .podpisane .wyjątkowy p (some k) → k ≤ p + godziny 90) ∧
  (∀ p k, s.etap = .uSejmu .wyjątkowy p (some k) → k ≤ p + godziny 90) ∧
  (∀ p k, s.etap = .trwa .wyjątkowy p (some k) 0 → k ≤ p + godziny 90) ∧
  (∀ p k e, s.etap = .trwa .wyjątkowy p (some k) (e + 1) → k ≤ p + godziny 150)

theorem wyjątkowy_w_granicach {s} (h : Osiągalny Z s) : wGranicach s := by
  induction h with
  | start => simp [wGranicach]
  | krok _ k ih =>
    cases k <;> simp_all [wGranicach, godziny] <;> omega

/-- Art. 230: stan wyjątkowy trwa łącznie najwyżej 150 dni. -/
theorem wyjątkowy_najwyżej_150_dni {s p k e} (h : Osiągalny Z s)
    (t : s.etap = .trwa .wyjątkowy p (some k) e) : k ≤ p + godziny 150 := by
  obtain ⟨_, _, a, b⟩ := wyjątkowy_w_granicach h
  cases e with
  | zero =>
    have := a p k t
    simp only [godziny] at *
    omega
  | succ n => exact b p k n t

/-- Art. 232: stan klęski wprowadza się najwyżej na 30 dni. -/
theorem klęska_najwyżej_30_dni {t x s p k} (h : Krok Z ⟨.normalny, t, x⟩ s)
    (e : s.etap = .trwa .klęskaŻywiołowa p (some k) 0) : k ≤ p + godziny 30 := by
  cases h with
  | wprowadzenieKlęski _ d =>
    cases e
    simp only [godziny]
    omega
  | wniosek => cases e

/-- Art. 229: stan wojenny wprowadza się bez terminu. -/
theorem wojenny_bez_terminu {t x s p k} (h : Krok Z ⟨.decyzjaPrezydenta .wojenny, t, x⟩ s)
    (e : s.etap = .podpisane .wojenny p k) : k = none := by
  cases h with
  | wprowadzenieWojennego => cases e; rfl
  | odmowa => cases e

/-- Granica 150 dni jest osiągalna. -/
theorem wyjątkowy_150_osiągalne (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.trwa .wyjątkowy 0 (some (0 + godziny 90 + godziny 60)) 1, 0, 0⟩ :=
  .krok (do_trwania_wyjątkowego w p s) (.przedłużenieWyjątkowego pełny s pełny_zgoda (Nat.le_refl _))

/-- Art. 230 ust. 2: przedłużenie tylko raz. -/
theorem jedno_przedłużenie_wyjątkowego {p k e t x s}
    (h : Krok Z ⟨.trwa .wyjątkowy p k (e + 1), t, x⟩ s) : s.etap.ustalony = true := by
  cases h <;> rfl

/-- Art. 232: przedłużanie stanu klęski nie ma limitu, więc przebieg może trwać bez końca. -/
theorem klęska_bez_końca (s : Z.sejmDziała = true) :
    ∃ f : Nat → Stan, f 0 = ⟨.trwa .klęskaŻywiołowa 0 (some (godziny 0)) 0, 0, 0⟩ ∧
      ∀ n, Krok Z (f n) (f (n + 1)) := by
  refine ⟨fun n => ⟨.trwa .klęskaŻywiołowa 0 (some (godziny n)) n, 0, 0⟩, rfl, fun n => ?_⟩
  have e : godziny (n + 1) = godziny n + godziny 1 := by
    simp only [godziny]
    omega
  show Krok Z ⟨.trwa .klęskaŻywiołowa 0 (some (godziny n)) n, 0, 0⟩
    ⟨.trwa .klęskaŻywiołowa 0 (some (godziny (n + 1))) (n + 1), 0, 0⟩
  rw [e]
  exact .przedłużenieKlęski pełny s pełny_zgoda

/-- Art. 229: bez działania Prezydenta stan wojenny bez terminu nie kończy się. -/
theorem wojenny_nie_wygasa (p : Z.prezydentDziała = false) {q e t x s}
    (k : Krok Z ⟨.trwa .wojenny q none e, t, x⟩ s) : s.etap.ustalony = false := by
  cases k <;> simp_all [Etap.ustalony]

/-- Art. 234: rozporządzenia z mocą ustawy tylko w stanie wojennym i gdy Sejm nie może
się zebrać. -/
theorem rozporządzenie_tylko_wojenny {a b} (k : Krok Z a b)
    (e : b.doZatwierdzenia = a.doZatwierdzenia + 1) :
    (∃ p q f, a.etap = .trwa .wojenny p q f) ∧ Z.sejmMożeObradować = false := by
  cases k <;> first
    | (simp only at e; omega)
    | (exact ⟨⟨_, _, _, rfl⟩, by assumption⟩)

/-- Art. 228 ust. 7: powrót do stanu normalnego najwcześniej po 90 dniach. -/
theorem powrót_po_90_dniach {r p k t x s} (h : Krok Z ⟨.poStanie r p k, t, x⟩ s) :
    k + godziny 90 ≤ t := by
  cases h with
  | końcowyPowrót w => exact w

/-! ## Blokady -/

/-- Art. 231 nie podaje skutku nieprzedstawienia rozporządzenia. -/
theorem nieprzedstawienie_blokuje (p : Z.prezydentDziała = false) {r q k t x} (u) :
    ¬ Krok Z ⟨.podpisane r q k, t, x⟩ u := by
  intro h
  cases h <;> simp_all

/-- Termin 48 godzin nie ma dalszego skutku: po jego upływie automat staje. -/
theorem po_48_godzinach_brak_kroku {r q k t x} (w : t > q + 48) (u) :
    ¬ Krok Z ⟨.podpisane r q k, t, x⟩ u := by
  intro h
  cases h with
  | przedstawienie _ a b =>
    have := a.2
    simp only [koniecTerminu] at this
    omega

/-- Art. 231 zd. 2 nie podaje skutku bierności Sejmu. -/
theorem bierność_sejmu_blokuje (s : Z.sejmDziała = false) {r q k t x} (u) :
    ¬ Krok Z ⟨.uSejmu r q k, t, x⟩ u := by
  intro h
  cases h <;> simp_all

/-! ## Zakończenie spraw w toku -/

/-- Niezmiennik potrzebny do postępu. -/
def etapPoprawny (s : Stan) : Prop :=
  match s.etap with
  | .podpisane r p k => s.chwila = p ∧ (k = none → r = .wojenny)
  | .uSejmu r _ k | .trwa r _ k _ => k = none → r = .wojenny
  | _ => True

theorem zawsze_poprawny {s} (h : Osiągalny Z s) : etapPoprawny s := by
  induction h with
  | start => simp [etapPoprawny]
  | krok _ k ih =>
    cases k <;> simp_all [etapPoprawny]

/-- Krok zamykający: etap przybliża się do stanu ustalonego. -/
def KrokZamykający (Z : Założenia) (a b : {s : Stan // Osiągalny Z s}) : Prop :=
  Krok Z a.1 b.1 ∧ b.1.etap.ranga < a.1.etap.ranga

structure WarunkiZakończenia (Z : Założenia) : Prop where
  sejm : Z.sejmDziała = true
  prezydent : Z.prezydentDziała = true

theorem postęp (w : WarunkiZakończenia Z) (s : {s : Stan // Osiągalny Z s})
    (n : s.1.etap.ustalony = false) : ∃ u, KrokZamykający Z s u := by
  obtain ⟨⟨e, t, x⟩, o⟩ := s
  have i := zawsze_poprawny o
  have hs := w.sejm
  have hp := w.prezydent
  cases e with
  | normalny | poStanie => simp [Etap.ustalony] at n
  | decyzjaPrezydenta r =>
    exact ⟨⟨_, .krok o (.odmowa hp)⟩, .odmowa hp, by simp [Etap.ranga]⟩
  | podpisane r q k =>
    have c : t = q := i.1
    subst c
    have a : wTerminie Z.kalendarz t (.godziny 48) t := w48 _ t
    exact ⟨⟨_, .krok o (.przedstawienie hp a (Nat.le_refl _))⟩,
      .przedstawienie hp a (Nat.le_refl _), by simp [Etap.ranga]⟩
  | uSejmu r q k =>
    have a := Krok.utrzymanie (Z := Z) (r := r) (p := q) (k := k) (t := t) (t' := t) (x := x) hs
      (Nat.le_refl _) (Nat.le_add_right _ _)
    exact ⟨⟨_, .krok o a⟩, a, by simp [Etap.ranga]⟩
  | trwa r q k f =>
    cases k with
    | none =>
      have c : r = .wojenny := i rfl
      subst c
      have a := Krok.końcowaDecyzja (Z := Z) (p := q) (e := f) (t := t) (t' := t) (x := x) hp
        (Nat.le_refl _)
      exact ⟨⟨_, .krok o a⟩, a, by simp [Etap.ranga]⟩
    | some g =>
      have a := Krok.koniec (Z := Z) (r := r) (p := q) (k := g) (e := f) (t := t) (t' := t)
        (x := x) (Nat.le_refl _) (Or.inr rfl)
      exact ⟨⟨_, .krok o a⟩, a, by simp [Etap.ranga]⟩

/-- Przy działaniu organów każdy osiągalny stan w toku można zamknąć. Stan klęski można
przedłużać bez końca, więc to możliwość, a nie gwarancja zakończenia. -/
theorem zakończenie (w : WarunkiZakończenia Z) {s} (o : Osiągalny Z s) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.ustalony = true := by
  obtain ⟨u, p, k⟩ := dojście_do_końca (R := KrokZamykający Z) (fun s => s.1.etap.ranga)
    (fun s => s.1.etap.ustalony = true) (fun r => r.2)
    (fun s n => postęp w s (by simpa using n)) ⟨s, o⟩
  exact ⟨u.1, Przebieg.przenieś Subtype.val (fun r => r.1) p, k⟩

/-! ## Art. 233 -/

/-- Katalogi z art. 233 ust. 1 i 3 są rozłączne. -/
theorem katalogi_rozłączne (p : Przepis) (h : nienaruszalne p = true) :
    dozwoloneWKlęsce p = false := by
  simp only [nienaruszalne, dozwoloneWKlęsce, List.contains_cons, List.contains_nil,
    Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq, Bool.or_false] at *
  cases d : (p.art == 22 || p.art == 50 || p.art == 64) with
  | true => simp at d; omega
  | false =>
    simp at d ⊢
    omega

/-- W stanie klęski można ograniczać tylko to, co da się ograniczyć w stanie wyjątkowym. -/
theorem klęska_węższa (p : Przepis) (h : możnaOgraniczyć .klęskaŻywiołowa p = true) :
    możnaOgraniczyć .wyjątkowy p = true := by
  simp only [możnaOgraniczyć] at *
  cases n : nienaruszalne p with
  | false => rfl
  | true =>
    have := katalogi_rozłączne p n
    rw [this] at h
    cases h

/-- Wolność zgromadzeń z art. 57 można ograniczyć w stanie wyjątkowym, ale nie w klęsce. -/
theorem zgromadzenia_tylko_w_wyjątkowym :
    możnaOgraniczyć .wyjątkowy ⟨57, 0, 0⟩ = true ∧
      możnaOgraniczyć .klęskaŻywiołowa ⟨57, 0, 0⟩ = false := by decide

/-- Art. 233 ust. 1: godność, życie i dostęp do sądu są chronione w każdym stanie. -/
theorem godność_i_życie_chronione (r : Rodzaj) :
    możnaOgraniczyć r ⟨30, 0, 0⟩ = false ∧ możnaOgraniczyć r ⟨38, 0, 0⟩ = false ∧
      możnaOgraniczyć r ⟨45, 0, 0⟩ = false := by
  cases r <;> decide

/-- Art. 41 jest podzielony: ust. 4 chroniony, ust. 1, 3 i 5 dozwolone w klęsce. -/
theorem art41_podzielony :
    nienaruszalne ⟨41, 4, 0⟩ = true ∧ dozwoloneWKlęsce ⟨41, 1, 0⟩ = true ∧
      dozwoloneWKlęsce ⟨41, 4, 0⟩ = false := by decide

/-- Art. 233 ust. 2: zakazanych jest dokładnie siedem motywów z przepisu. -/
theorem wszystkie_motywy_zakazane (m : Motyw) : motywZakazany m = true ↔ m ≠ .inny := by
  cases m <;> simp [motywZakazany]

/-- Art. 233 ust. 2: zakazany motyw wyklucza ograniczenie nawet dozwolonego prawa. -/
theorem zakazany_motyw (r p m) (h : motywZakazany m = true) :
    ograniczenieDopuszczalne r p m = false := by
  simp [ograniczenieDopuszczalne, h]

/-- Dozwolone ograniczenie z innego motywu przechodzi. -/
theorem ograniczenie_dozwolone_osiągalne :
    ograniczenieDopuszczalne .klęskaŻywiołowa ⟨64, 0, 0⟩ .inny = true := by decide

/-- Art. 228 ust. 6. -/
theorem konstytucja_niezmienna : niezmiennyWStanie .konstytucja = true ∧
    niezmiennyWStanie .innaUstawa = false := by decide

/-! ## Art. 228 ust. 7: okres ochronny z historii -/

/-- Stan nadzwyczajny mieści się w okresie ochronnym, więc spełnia warunek `stanWOkresie`. -/
theorem stan_w_okresie (h : Historia) (t : Nat) (s : wStanie h t = true) :
    wOkresieOchronnym h t = true := by
  simp only [wStanie, wOkresieOchronnym, List.any_eq_true, Bool.and_eq_true,
    decide_eq_true_eq] at *
  obtain ⟨x, m, a, b⟩ := s
  exact ⟨x, m, a, by omega⟩

/-- Poza okresem ochronnym dzień leży poza każdym przedziałem historii. -/
theorem poza_okresem {h : Historia} {t x} (o : wOkresieOchronnym h t = false) (m : x ∈ h) :
    t < x.1 ∨ t > x.2 + 90 := by
  simp only [wOkresieOchronnym, List.any_eq_false, Bool.not_eq_true, Bool.and_eq_false_iff,
    decide_eq_false_iff_not] at o
  have := o x m
  omega

/-- Zakończony stan daje okres ochronny obejmujący 90 dni po końcu. -/
theorem koniec_stanu_daje_okres (p k t : Nat) (a : p ≤ t) (b : t ≤ k + 90) :
    wOkresieOchronnym [(p, k)] t = true := by
  simp [wOkresieOchronnym, a, b]

/-- Pierwszy dzień po okresie ochronnym nie jest chroniony. -/
theorem dzień_po_okresie (p k : Nat) : wOkresieOchronnym [(p, k)] (k + 91) = false := by
  simp [wOkresieOchronnym]

private theorem foldr_max_ge (l : List Nat) (k : Nat) : k ≤ l.foldr max k := by
  induction l with
  | nil => exact Nat.le_refl _
  | cons x r ih =>
    simp only [List.foldr_cons]
    omega

private theorem foldr_max_mem {l : List Nat} {x : Nat} (k : Nat) (m : x ∈ l) :
    x ≤ l.foldr max k := by
  induction l with
  | nil => cases m
  | cons y r ih =>
    simp only [List.foldr_cons]
    cases m with
    | head => omega
    | tail _ q =>
      have := ih q
      omega

/-- Założenie S7: kadencja nie kończy się wcześniej niż przed przedłużeniem. -/
theorem kadencja_nie_krótsza (h : Historia) (k : Nat) : k ≤ przedłużonaKadencja h k := by
  simp only [przedłużonaKadencja]
  split
  · exact foldr_max_ge _ _
  · exact Nat.le_refl _

/-- Założenie S7: przedłużona kadencja kończy się poza okresem ochronnym. -/
theorem kadencja_poza_okresem (h : Historia) (k : Nat) :
    wOkresieOchronnym h (przedłużonaKadencja h k) = false := by
  simp only [przedłużonaKadencja]
  split
  · cases w : wOkresieOchronnym h ((h.map fun x => x.2 + 91).foldr max k) with
    | false => rfl
    | true =>
      simp only [wOkresieOchronnym, List.any_eq_true, Bool.and_eq_true,
        decide_eq_true_eq] at w
      obtain ⟨x, m, _, b⟩ := w
      have := foldr_max_mem k (List.mem_map_of_mem (f := fun x => x.2 + 91) m)
      omega
  · simp_all

end Konstytucja.StanyNadzwyczajne
