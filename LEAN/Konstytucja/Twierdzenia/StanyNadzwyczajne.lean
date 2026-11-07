import Konstytucja.Procedury.StanyNadzwyczajne

/-! # Własności stanów nadzwyczajnych -/

namespace Konstytucja.StanyNadzwyczajne

open Konstytucja

variable {Z : Założenia}

private def pełny : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩

private theorem pełny_zgoda : zgodaSejmu pełny := by
  simp [zgodaSejmu, kworum, większośćZwykła, pełny, Głosowanie.głosujący, Izba.ustawowaLiczba]

private theorem pełny_uchyla : uchylenie Z pełny := by
  cases m : Z.mianownik <;>
    simp [uchylenie, kworum, większośćBezwzględna, pełny, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba, m]

private theorem w48 (K : Kalendarz) (t : Nat) : wTerminie K t (.godziny 48) t := by
  simp [wTerminie, koniecTerminu]

private theorem dk_none (t : Nat) : doKońca none t := trivial

private theorem dk_some {t k : Nat} (h : t ≤ k) : doKońca (some k) t := h

/-! ## Osiągalność -/

theorem do_decyzji (r : Rodzaj) (n : r ≠ .klęskaŻywiołowa) (w : przesłankiSpełnione Z r) :
    Osiągalny Z ⟨.decyzjaPrezydenta r, 0, 0⟩ :=
  .krok .start (.wniosek r n w)

theorem do_trwania_wyjątkowego (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.trwa .wyjątkowy 0 (some (0 + godziny 90)) 0, 0, 0⟩ :=
  .krok (.krok (.krok (do_decyzji .wyjątkowy (by decide) w)
    (.wprowadzenieWyjątkowego p (Nat.le_refl _)))
    (.przedstawienie p (w48 _ 0) (Nat.le_refl _) (dk_some (Nat.zero_le _))))
    (.utrzymanie s (Nat.le_refl _) (Nat.le_add_right _ _) (dk_some (Nat.zero_le _)))

theorem do_podpisania_wojennego (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) : Osiągalny Z ⟨.podpisane .wojenny 0 none, 0, 0⟩ :=
  .krok (do_decyzji .wojenny (by decide) w) (.wprowadzenieWojennego p)

theorem do_sejmu_wojennego (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) : Osiągalny Z ⟨.uSejmu .wojenny 0 none 0, 0, 0⟩ :=
  .krok (do_podpisania_wojennego w p) (.przedstawienie p (w48 _ 0) (Nat.le_refl _) (dk_none _))

theorem wojenny_osiągalny (w : przesłankiSpełnione Z .wojenny) (p : Z.prezydentDziała = true)
    (s : Z.sejmDziała = true) : Osiągalny Z ⟨.trwa .wojenny 0 none 0, 0, 0⟩ :=
  .krok (do_sejmu_wojennego w p)
    (.utrzymanie s (Nat.le_refl _) (Nat.le_add_right _ _) (dk_none _))

theorem klęska_osiągalna (w : przesłankiSpełnione Z .klęskaŻywiołowa) :
    Osiągalny Z ⟨.trwa .klęskaŻywiołowa 0 (some (0 + godziny 30)) 0, 0, 0⟩ :=
  .krok .start (.wprowadzenieKlęski w (Nat.le_refl _))

theorem uchylenie_osiągalne (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .poStanie .wojenny 0 0 :=
  ⟨_, .krok (do_sejmu_wojennego w p)
    (.uchylenie pełny s pełny_uchyla (Nat.le_refl _) (Nat.le_add_right _ _) (dk_none _)), rfl⟩

theorem odmowa_prezydenta_osiągalna (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) : Osiągalny Z ⟨.normalny, 0, 0⟩ :=
  .krok (do_decyzji .wyjątkowy (by decide) w) (.odmowa p)

/-- Po zakończeniu stanu automat może odczekać 90 dni i wrócić do stanu normalnego. -/
theorem powrót_do_normalnego (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.normalny, 0 + godziny 90, 0⟩ := by
  have a := Osiągalny.krok (do_sejmu_wojennego w p)
    (.uchylenie (t' := 0) pełny s pełny_uchyla (Nat.le_refl _) (Nat.le_add_right _ _) (dk_none _))
  have b := Osiągalny.krok a (.czekanie (t' := 0 + godziny 90) (Nat.zero_le _) trivial)
  exact .krok b (.końcowyPowrót (Nat.le_refl _))

/-! ## Ograniczenia -/

/-- Art. 229–230: Prezydent działa tylko na wniosek Rady Ministrów i przy przesłankach. -/
theorem decyzja_wymaga_przesłanek {a b r} (k : Krok Z a b)
    (e : b.etap = .decyzjaPrezydenta r) (n : a.etap = .normalny) :
    przesłankiSpełnione Z r := by
  cases k with
  | wniosek _ _ h => cases e; exact h
  | czekanie => simp_all
  | zatwierdzenie => simp_all
  | _ => first | cases e | cases n

/-- Art. 232: stan klęski nie idzie przez Prezydenta. -/
theorem klęska_bez_prezydenta {s} (o : Osiągalny Z s) :
    s.etap ≠ .decyzjaPrezydenta .klęskaŻywiołowa := by
  induction o with
  | start => simp
  | krok _ k ih =>
    intro e
    cases k with
    | wniosek _ n _ => cases e; exact n rfl
    | czekanie => exact ih e
    | zatwierdzenie => exact ih e
    | _ => cases e

/-- Art. 231: przedstawienie Sejmowi w ciągu 48 godzin od podpisania. -/
theorem przedstawienie_w_48_godzin {r p k t x s}
    (h : Krok Z ⟨.podpisane r p k, t, x⟩ s) (e : ∃ q c o, s.etap = .uSejmu r q c o) :
    s.chwila ≤ p + 48 := by
  cases h with
  | przedstawienie _ w _ _ => exact w.2
  | wygaśnięciePodpisanego => obtain ⟨_, _, _, e⟩ := e; cases e
  | czekanie => obtain ⟨_, _, _, e⟩ := e; cases e
  | zatwierdzenie => obtain ⟨_, _, _, e⟩ := e; cases e

/-- Niezmiennik limitów. `koniec` planowany i rzeczywisty mieści się w granicach art. 230. -/
def wGranicach (s : Stan) : Prop :=
  (∀ p k, s.etap = .podpisane .wyjątkowy p (some k) → k ≤ p + godziny 90) ∧
  (∀ p k q, s.etap = .uSejmu .wyjątkowy p (some k) q → k ≤ p + godziny 90) ∧
  (∀ p k, s.etap = .trwa .wyjątkowy p (some k) 0 → k ≤ p + godziny 90) ∧
  (∀ p k e, s.etap = .trwa .wyjątkowy p (some k) (e + 1) → k ≤ p + godziny 150) ∧
  (∀ p q, s.etap = .poStanie .wyjątkowy p q → q ≤ p + godziny 150)

/-- Niezmiennik obowiązywania: chwila nie mija początku ani planowanego końca. -/
def etapPoprawny (s : Stan) : Prop :=
  match s.etap with
  | .podpisane r p k | .uSejmu r p k _ | .trwa r p k _ =>
      p ≤ s.chwila ∧ (k = none → r = .wojenny) ∧ doKońca k s.chwila
  | _ => True

private theorem poprawny_czekanie {e t t' x} (i : etapPoprawny ⟨e, t, x⟩) (a : t ≤ t')
    (m : możeCzekać e t') : etapPoprawny ⟨e, t', x⟩ := by
  cases e <;> simp_all [etapPoprawny, możeCzekać] <;> omega

theorem zawsze_poprawny {s} (h : Osiągalny Z s) : etapPoprawny s := by
  induction h with
  | start => simp [etapPoprawny]
  | krok _ k ih =>
    cases k with
    | czekanie a m => exact poprawny_czekanie ih a m
    | zatwierdzenie => exact ih
    | rozporządzenieZMocąUstawy => exact ih
    | przedstawienie _ w _ d => exact ⟨w.1, ih.2.1, d⟩
    | utrzymanie _ a _ d => exact ⟨Nat.le_trans ih.1 a, ih.2.1, d⟩
    | przedłużenieWyjątkowego =>
      exact ⟨ih.1, by simp, Nat.le_trans ih.2.2 (Nat.le_add_right _ _)⟩
    | przedłużenieKlęski =>
      exact ⟨ih.1, by simp, Nat.le_trans ih.2.2 (Nat.le_add_right _ _)⟩
    | wprowadzenieWojennego => exact ⟨Nat.le_refl _, fun _ => rfl, trivial⟩
    | wprowadzenieWyjątkowego => exact ⟨Nat.le_refl _, by simp, Nat.le_add_right _ _⟩
    | wprowadzenieKlęski => exact ⟨Nat.le_refl _, by simp, Nat.le_add_right _ _⟩
    | _ => trivial

theorem wyjątkowy_w_granicach {s} (h : Osiągalny Z s) : wGranicach s := by
  induction h with
  | start => simp [wGranicach]
  | krok o k ih =>
    have hp := zawsze_poprawny o
    cases k with
    | czekanie => exact ih
    | zatwierdzenie => exact ih
    | @przedstawienie r q c _ _ _ =>
      cases r <;> cases c <;> simp_all [wGranicach]
    | @utrzymanie r q c _ _ _ =>
      cases r <;> cases c <;> simp_all [wGranicach]
    | @uchylenie r q c _ _ _ =>
      cases r <;> cases c <;> simp_all [wGranicach, doKońca, etapPoprawny, godziny] <;> omega
    | @wygaśnięciePodpisanego r =>
      cases r <;> simp_all [wGranicach, godziny] <;> omega
    | @wygaśnięcieUSejmu r =>
      cases r <;> simp_all [wGranicach, godziny] <;> omega
    | @koniec r q c e =>
      cases r <;> cases e <;> simp_all [wGranicach, godziny] <;> omega
    | _ => simp_all [wGranicach, godziny] <;> omega

/-- Art. 230: rzeczywisty koniec stanu wyjątkowego najwyżej 150 dni po początku. -/
theorem wyjątkowy_faktycznie_najwyżej_150_dni {s p q} (h : Osiągalny Z s)
    (t : s.etap = .poStanie .wyjątkowy p q) : q ≤ p + godziny 150 :=
  (wyjątkowy_w_granicach h).2.2.2.2 p q t

/-- Art. 230: planowany koniec stanu wyjątkowego najwyżej 150 dni po początku. -/
theorem wyjątkowy_najwyżej_150_dni {s p k e} (h : Osiągalny Z s)
    (t : s.etap = .trwa .wyjątkowy p (some k) e) : k ≤ p + godziny 150 := by
  obtain ⟨_, _, a, b, _⟩ := wyjątkowy_w_granicach h
  cases e with
  | zero =>
    have := a p k t
    simp only [godziny] at *
    omega
  | succ n => exact b p k n t

/-- Dopóki stan wyjątkowy obowiązuje, chwila nie mija 150. dnia od początku. -/
theorem obowiązywanie_najwyżej_150_dni {s p k e} (h : Osiągalny Z s)
    (t : s.etap = .trwa .wyjątkowy p (some k) e) : s.chwila ≤ p + godziny 150 := by
  have a := wyjątkowy_najwyżej_150_dni h t
  have b := zawsze_poprawny h
  obtain ⟨u, c, x⟩ := s
  simp only at t
  subst t
  have d : c ≤ k := b.2.2
  show c ≤ _
  omega

/-- Art. 232: stan klęski wprowadza się najwyżej na 30 dni. -/
theorem klęska_najwyżej_30_dni {t x s p k} (h : Krok Z ⟨.normalny, t, x⟩ s)
    (e : s.etap = .trwa .klęskaŻywiołowa p (some k) 0) : k ≤ p + godziny 30 := by
  cases h with
  | wprowadzenieKlęski _ d =>
    cases e
    simp only [godziny]
    omega
  | wniosek => cases e
  | czekanie => cases e
  | zatwierdzenie => cases e

/-- Art. 229: stan wojenny wprowadza się bez terminu. -/
theorem wojenny_bez_terminu {t x s p k} (h : Krok Z ⟨.decyzjaPrezydenta .wojenny, t, x⟩ s)
    (e : s.etap = .podpisane .wojenny p k) : k = none := by
  cases h with
  | wprowadzenieWojennego => cases e; rfl
  | odmowa => cases e
  | czekanie => cases e
  | zatwierdzenie => cases e

/-- Granica 150 dni jest osiągalna: stan obowiązuje przez pełny czas i dopiero się kończy. -/
theorem wyjątkowy_150_osiągalne (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.poStanie .wyjątkowy 0 (0 + godziny 90 + godziny 60),
      0 + godziny 90 + godziny 60, 0⟩ := by
  have a := Osiągalny.krok (do_trwania_wyjątkowego w p s)
    (.przedłużenieWyjątkowego pełny s pełny_zgoda (Nat.le_refl _))
  exact .krok a (.koniec (Nat.zero_le _) (Nat.le_refl _))

/-- Stan wyjątkowy krótszy od czasu rozpatrywania wygasa także przed decyzją Sejmu. -/
theorem wygaśnięcie_przed_decyzją (w : przesłankiSpełnione Z .wyjątkowy)
    (p : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.poStanie .wyjątkowy 0 (0 + godziny 1), 0 + godziny 1, 0⟩ :=
  .krok (.krok (do_decyzji .wyjątkowy (by decide) w)
    (.wprowadzenieWyjątkowego p (by decide))) (.wygaśnięciePodpisanego (Nat.zero_le _))

/-- Art. 230 ust. 2: po przedłużeniu nie ma następnego. -/
theorem jedno_przedłużenie_wyjątkowego {p k e t x s q c f}
    (h : Krok Z ⟨.trwa .wyjątkowy p k (e + 1), t, x⟩ s)
    (w : s.etap = .trwa .wyjątkowy q c f) : f = e + 1 := by
  cases h <;> first | (cases w; rfl) | cases w

/-- Art. 232: przedłużanie stanu klęski nie ma limitu, także w upływającym czasie. -/
theorem klęska_bez_końca (s : Z.sejmDziała = true)
    (w : przesłankiSpełnione Z .klęskaŻywiołowa) (n : Nat) :
    Osiągalny Z ⟨.trwa .klęskaŻywiołowa 0 (some (0 + godziny 30 + godziny n)) n,
      0 + godziny 30 + godziny n, 0⟩ := by
  induction n with
  | zero =>
    exact .krok (klęska_osiągalna w)
      (.czekanie (Nat.zero_le _) (by simp only [możeCzekać, doKońca, godziny]; omega))
  | succ n ih =>
    have e : godziny (n + 1) = godziny n + godziny 1 := by
      simp only [godziny]
      omega
    rw [e]
    have a := Osiągalny.krok ih (.przedłużenieKlęski (d := 1) pełny s pełny_zgoda)
    rw [← Nat.add_assoc] at *
    exact .krok a (.czekanie (Nat.le_add_right _ _) (by simp [możeCzekać, doKońca]))

/-- Stan klęski może obowiązywać dowolnie długo. -/
theorem klęska_dowolnie_długo (s : Z.sejmDziała = true)
    (w : przesłankiSpełnione Z .klęskaŻywiołowa) (n : Nat) :
    ∃ u p k e, Osiągalny Z u ∧ u.etap = .trwa .klęskaŻywiołowa p k e ∧ u.chwila > n :=
  ⟨_, _, _, _, klęska_bez_końca s w (n + 1), rfl, by simp only [godziny]; omega⟩

/-- Art. 229: bez działania Prezydenta stan wojenny bez terminu nie kończy się. -/
theorem wojenny_nie_wygasa (p : Z.prezydentDziała = false) {q e t x s}
    (k : Krok Z ⟨.trwa .wojenny q none e, t, x⟩ s) : s.etap.ustalony = false := by
  cases k <;> simp_all [Etap.ustalony]

/-- Art. 234: rozporządzenia z mocą ustawy tylko w stanie wojennym i gdy Sejm nie może
się zebrać. -/
theorem rozporządzenie_tylko_wojenny {a b} (k : Krok Z a b)
    (e : b.doZatwierdzenia = a.doZatwierdzenia + 1) :
    (∃ p q f, a.etap = .trwa .wojenny p q f) ∧ Z.sejmMożeObradować a.chwila = false := by
  cases k with
  | rozporządzenieZMocąUstawy _ h => exact ⟨⟨_, _, _, rfl⟩, h⟩
  | _ => simp only at e; omega

/-- Art. 234: wydanie w chwili bez Sejmu i zatwierdzenie, gdy Sejm znów obraduje. -/
theorem zatwierdzenie_osiągalne (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true)
    (a : Z.sejmMożeObradować 0 = false) (b : Z.sejmMożeObradować 1 = true) :
    Osiągalny Z ⟨.trwa .wojenny 0 none 0, 1, 0⟩ := by
  have c := Osiągalny.krok (wojenny_osiągalny w p s) (.rozporządzenieZMocąUstawy p a)
  have d := Osiągalny.krok c (.czekanie (t' := 1) (Nat.zero_le _) trivial)
  exact .krok d (.zatwierdzenie s b)

/-- Art. 234: zatwierdzenie jest możliwe także po zakończeniu stanu wojennego. -/
theorem zatwierdzenie_po_stanie (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = true)
    (a : Z.sejmMożeObradować 0 = false) (b : Z.sejmMożeObradować 1 = true) :
    Osiągalny Z ⟨.poStanie .wojenny 0 0, 1, 0⟩ := by
  have c := Osiągalny.krok (wojenny_osiągalny w p s) (.rozporządzenieZMocąUstawy p a)
  have d := Osiągalny.krok c (.końcowaDecyzja (t' := 0) p (Nat.le_refl _))
  have e := Osiągalny.krok d (.czekanie (t' := 1) (Nat.zero_le _) trivial)
  exact .krok e (.zatwierdzenie s b)

/-- Art. 228 ust. 7: powrót do stanu normalnego najwcześniej po 90 dniach. -/
theorem powrót_po_90_dniach {r p k t x s} (h : Krok Z ⟨.poStanie r p k, t, x⟩ s)
    (e : s.etap = .normalny) : k + godziny 90 ≤ t := by
  cases h with
  | końcowyPowrót w => exact w
  | czekanie => cases e
  | zatwierdzenie => cases e

/-- Czas nie cofa się w osiągalnych przebiegach. -/
theorem czas_nie_cofa {a b} (h : Osiągalny Z a) (k : Krok Z a b) : a.chwila ≤ b.chwila := by
  have i := zawsze_poprawny h
  cases k with
  | czekanie p _ => exact p
  | przedstawienie _ _ p _ => exact p
  | utrzymanie _ p _ _ => exact p
  | uchylenie _ _ _ p _ _ => exact p
  | koniec p _ => exact p
  | końcowaDecyzja _ p => exact p
  | wygaśnięciePodpisanego p => exact p
  | wygaśnięcieUSejmu p => exact p
  | wprowadzenieKlęski => exact Nat.le_refl _
  | _ => simp

/-! ## Blokady -/

/-- Art. 231 nie podaje skutku spóźnienia: po 48 godzinach nie ma przedstawienia. -/
theorem po_48_godzinach_bez_przedstawienia {r q k t x s} (w : t > q + 48)
    (h : Krok Z ⟨.podpisane r q k, t, x⟩ s) (e : ∃ c d o, s.etap = .uSejmu r c d o) : False := by
  cases h with
  | przedstawienie _ a b _ =>
    have := a.2
    simp only [koniecTerminu] at this
    omega
  | wygaśnięciePodpisanego => obtain ⟨_, _, _, e⟩ := e; cases e
  | czekanie => obtain ⟨_, _, _, e⟩ := e; cases e
  | zatwierdzenie => obtain ⟨_, _, _, e⟩ := e; cases e

/-- Osiągalny przypadek spóźnienia: stan wojenny bez terminu nigdy nie wyjdzie z etapu
`podpisane`, gdy minęło 48 godzin. -/
theorem spóźnienie_wojennego (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.podpisane .wojenny 0 none, 49, 0⟩ ∧
      ∀ t u, 49 ≤ t → Krok Z ⟨.podpisane .wojenny 0 none, t, 0⟩ u →
        u.etap = .podpisane .wojenny 0 none := by
  refine ⟨.krok (do_podpisania_wojennego w p) (.czekanie (Nat.zero_le _) trivial), ?_⟩
  intro t u a k
  cases k with
  | czekanie => rfl
  | przedstawienie _ q _ _ =>
    have := q.2
    simp only [koniecTerminu] at this
    omega

/-- Art. 231 zd. 2: przy bierności Sejmu stan wojenny czeka w osiągalnym etapie. -/
theorem bierność_sejmu_blokuje (w : przesłankiSpełnione Z .wojenny)
    (p : Z.prezydentDziała = true) (s : Z.sejmDziała = false) :
    Osiągalny Z ⟨.uSejmu .wojenny 0 none 0, 0, 0⟩ ∧
      ∀ t u, Krok Z ⟨.uSejmu .wojenny 0 none 0, t, 0⟩ u →
        u.etap = .uSejmu .wojenny 0 none 0 := by
  refine ⟨do_sejmu_wojennego w p, fun t u k => ?_⟩
  cases k with
  | czekanie => rfl
  | utrzymanie h => rw [s] at h; cases h
  | uchylenie _ h => rw [s] at h; cases h

/-- Założenie S11: czekanie nie przedłuża „niezwłocznie”, bo termin biegnie od otrzymania. -/
theorem sejm_po_terminie_nie_rozstrzyga {r q k o t x s} (w : t > o + Z.niezwłocznie)
    (h : Krok Z ⟨.uSejmu r q k o, t, x⟩ s) (e : ∃ a b c, s.etap = .trwa a b c 0) : False := by
  cases h with
  | utrzymanie _ a b _ => omega
  | uchylenie => obtain ⟨_, _, _, e⟩ := e; cases e
  | wygaśnięcieUSejmu => obtain ⟨_, _, _, e⟩ := e; cases e
  | czekanie => obtain ⟨_, _, _, e⟩ := e; cases e
  | zatwierdzenie => obtain ⟨_, _, _, e⟩ := e; cases e

/-- Spóźnienie Sejmu jest osiągalne: stan wojenny pozostaje na tym etapie. -/
theorem spóźnienie_sejmu (w : przesłankiSpełnione Z .wojenny) (p : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.uSejmu .wojenny 0 none 0, Z.niezwłocznie + 1, 0⟩ ∧
      ∀ u, Krok Z ⟨.uSejmu .wojenny 0 none 0, Z.niezwłocznie + 1, 0⟩ u →
        u.etap = .uSejmu .wojenny 0 none 0 := by
  refine ⟨.krok (do_sejmu_wojennego w p) (.czekanie (Nat.zero_le _) trivial), fun u k => ?_⟩
  cases k with
  | czekanie => rfl
  | utrzymanie _ _ b _ => omega
  | uchylenie _ _ _ b _ => omega

/-! ## Zakończenie spraw w toku -/

/-- Art. 231: stan, w którym nie przekroczono ani 48 godzin, ani „niezwłocznie”. -/
def terminDotrzymany (Z : Założenia) (s : Stan) : Prop :=
  (∀ r p k, s.etap = .podpisane r p k → s.chwila ≤ p + 48) ∧
    ∀ r p k o, s.etap = .uSejmu r p k o → s.chwila ≤ o + Z.niezwłocznie

/-- Stany osiągalne bez spóźnienia z art. 231. -/
abbrev StanWToku (Z : Założenia) := {s : Stan // Osiągalny Z s ∧ terminDotrzymany Z s}

/-- Krok zamykający: etap przybliża się do stanu ustalonego. -/
def KrokZamykający (Z : Założenia) (a b : StanWToku Z) : Prop :=
  Krok Z a.1 b.1 ∧ b.1.etap.ranga < a.1.etap.ranga

structure WarunkiZakończenia (Z : Założenia) : Prop where
  sejm : Z.sejmDziała = true
  prezydent : Z.prezydentDziała = true

theorem postęp (w : WarunkiZakończenia Z) (s : StanWToku Z)
    (n : s.1.etap.ustalony = false) : ∃ u, KrokZamykający Z s u := by
  obtain ⟨⟨e, t, x⟩, o, d⟩ := s
  have i := zawsze_poprawny o
  have hs := w.sejm
  have hp := w.prezydent
  have bez : ∀ u : Stan, (∀ r p k, u.etap ≠ .podpisane r p k) →
      (∀ r p k o, u.etap ≠ .uSejmu r p k o) → terminDotrzymany Z u :=
    fun u a b => ⟨fun r p k e => absurd e (a r p k), fun r p k o e => absurd e (b r p k o)⟩
  cases e with
  | normalny | poStanie => simp [Etap.ustalony] at n
  | decyzjaPrezydenta r =>
    exact ⟨⟨_, .krok o (.odmowa hp), bez _ (by simp) (by simp)⟩, .odmowa hp,
      by simp [Etap.ranga]⟩
  | podpisane r q k =>
    have a : wTerminie Z.kalendarz q (.godziny 48) t := ⟨i.1, d.1 r q k rfl⟩
    have b := Krok.przedstawienie (r := r) hp a (Nat.le_refl t) i.2.2 (x := x)
    refine ⟨⟨_, .krok o b, ⟨by simp, ?_⟩⟩, b, by simp [Etap.ranga]⟩
    intro r' p' k' o' e
    cases e
    exact Nat.le_add_right _ _
  | uSejmu r q k c =>
    have a := Krok.utrzymanie (Z := Z) (r := r) (p := q) (q := c) (t := t) (t' := t) (x := x) hs
      (Nat.le_refl _) (d.2 r q k c rfl) i.2.2
    exact ⟨⟨_, .krok o a, bez _ (by simp) (by simp)⟩, a, by simp [Etap.ranga]⟩
  | trwa r q k f =>
    cases k with
    | none =>
      have c : r = .wojenny := i.2.1 rfl
      subst c
      have a := Krok.końcowaDecyzja (Z := Z) (p := q) (e := f) (t := t) (t' := t) (x := x) hp
        (Nat.le_refl _)
      exact ⟨⟨_, .krok o a, bez _ (by simp) (by simp)⟩, a, by simp [Etap.ranga]⟩
    | some g =>
      have a := Krok.koniec (Z := Z) (r := r) (p := q) (k := g) (e := f) (t := t) (t' := t)
        (x := x) (Nat.le_refl _) i.2.2
      exact ⟨⟨_, .krok o a, bez _ (by simp) (by simp)⟩, a, by simp [Etap.ranga]⟩

/-- Przy działaniu organów każdy osiągalny stan bez spóźnienia z art. 231 można zamknąć.
Stan klęski można przedłużać bez końca, więc to możliwość, a nie gwarancja zakończenia. -/
theorem zakończenie (w : WarunkiZakończenia Z) {s} (o : Osiągalny Z s)
    (d : terminDotrzymany Z s) : ∃ u, Przebieg (Krok Z) s u ∧ u.etap.ustalony = true := by
  obtain ⟨u, p, k⟩ := dojście_do_końca (R := KrokZamykający Z) (fun s => s.1.etap.ranga)
    (fun s => s.1.etap.ustalony = true) (fun r => r.2)
    (fun s n => postęp w s (by simpa using n)) ⟨s, o, d⟩
  exact ⟨u.1, Przebieg.przenieś Subtype.val (fun r => r.1) p, k⟩

/-! ## Art. 233 -/

/-- Art. 233 ust. 1: pełna charakterystyka katalogu, dla każdego przepisu. -/
theorem art233_ust1_pełny (p : Przepis) :
    nienaruszalne p = true ↔
      (p.art = 30 ∨ p.art = 34 ∨ p.art = 36 ∨ p.art = 38 ∨ p.art = 39 ∨ p.art = 40 ∨
        p.art = 42 ∨ p.art = 45 ∨ p.art = 47 ∨ p.art = 48 ∨ p.art = 53 ∨ p.art = 63 ∨
        p.art = 72) ∨ (p.art = 41 ∧ p.ust = 4) := by
  simp [nienaruszalne]

/-- Art. 233 ust. 3: pełna charakterystyka katalogu, dla każdego przepisu. -/
theorem art233_ust3_pełny (p : Przepis) :
    dozwoloneWKlęsce p = true ↔
      (p.art = 22 ∨ p.art = 50 ∨ p.art = 64) ∨
        (p.art = 41 ∧ (p.ust = 1 ∨ p.ust = 3 ∨ p.ust = 5)) ∨ (p.art = 52 ∧ p.ust = 1) ∨
        (p.art = 59 ∧ p.ust = 3) ∨ (p.art = 65 ∧ p.ust = 1) ∨
        (p.art = 66 ∧ (p.ust = 1 ∨ p.ust = 2)) := by
  simp [dozwoloneWKlęsce]
  omega

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

/-! ## Przedłużenie kadencji -/

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

theorem wolne_od_końca_ochrony (h : Historia) {t} (w : koniecOchrony h ≤ t) :
    wOkresieOchronnym h t = false := by
  cases o : wOkresieOchronnym h t with
  | false => rfl
  | true =>
    simp only [wOkresieOchronnym, List.any_eq_true, Bool.and_eq_true,
      decide_eq_true_eq] at o
    obtain ⟨x, m, _, b⟩ := o
    have := foldr_max_mem 0 (List.mem_map_of_mem (f := fun x => x.2 + 91) m)
    simp only [koniecOchrony] at w
    omega

theorem pierwszyWolny_nie_wcześniej (h f t) : t ≤ pierwszyWolny h f t := by
  induction f generalizing t with
  | zero => exact Nat.le_refl _
  | succ f ih =>
    simp only [pierwszyWolny]
    split
    · have := ih (t + 1)
      omega
    · exact Nat.le_refl _

theorem pierwszyWolny_wolny (h : Historia) (f t) (w : koniecOchrony h ≤ t + f) :
    wOkresieOchronnym h (pierwszyWolny h f t) = false := by
  induction f generalizing t with
  | zero => exact wolne_od_końca_ochrony h w
  | succ f ih =>
    simp only [pierwszyWolny]
    split
    · exact ih (t + 1) (by omega)
    · simp_all

theorem pierwszyWolny_najmniejszy (h : Historia) (f t u) (a : t ≤ u)
    (b : u < pierwszyWolny h f t) : wOkresieOchronnym h u = true := by
  induction f generalizing t with
  | zero => simp only [pierwszyWolny] at b; omega
  | succ f ih =>
    simp only [pierwszyWolny] at b
    split at b
    · rename_i o
      cases q : Nat.decEq t u with
      | isTrue e => subst e; simpa using o
      | isFalse e => exact ih (t + 1) (by omega) b
    · omega

/-- Założenie S7: kadencja nie kończy się wcześniej niż przed przedłużeniem. -/
theorem kadencja_nie_krótsza (h : Historia) (k : Nat) : k ≤ przedłużonaKadencja h k :=
  pierwszyWolny_nie_wcześniej _ _ _

/-- Założenie S7: przedłużona kadencja kończy się poza okresem ochronnym. -/
theorem kadencja_poza_okresem (h : Historia) (k : Nat) :
    wOkresieOchronnym h (przedłużonaKadencja h k) = false :=
  pierwszyWolny_wolny h _ k (by omega)

/-- Założenie S7: to pierwszy taki dzień, bez niezwiązanych późniejszych stanów. -/
theorem kadencja_najkrótsza (h : Historia) (k u : Nat) (a : k ≤ u)
    (b : u < przedłużonaKadencja h k) : wOkresieOchronnym h u = true :=
  pierwszyWolny_najmniejszy h _ k u a b

set_option maxRecDepth 20000 in
/-- Niezwiązany późniejszy stan nie wydłuża kadencji. -/
theorem odległy_stan_bez_wpływu : przedłużonaKadencja [(0, 10), (1000, 1010)] 5 = 101 := by
  decide

set_option maxRecDepth 20000 in
/-- Stykające się okresy liczą się razem. -/
theorem stykające_się_okresy : przedłużonaKadencja [(0, 10), (90, 95)] 5 = 186 := by decide

end Konstytucja.StanyNadzwyczajne
