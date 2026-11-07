import Konstytucja.Procedury.WybórPrezydenta

/-! # Własności wyboru Prezydenta -/

namespace Konstytucja.WybórPrezydenta

open Konstytucja

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

/-! ## Kandydaci i większość -/

/-- Art. 127 ust. 3: 34 lata nie wystarczają. -/
theorem wymagany_wiek (c : Kandydat) (h : c.wiekWDniuWyborów = 34) : ¬ dopuszczalny c := by
  intro d
  have := d.2.1
  omega

/-- Art. 127 ust. 2: po dwóch kadencjach nie można kandydować. -/
theorem dwie_kadencje_wykluczają (c : Kandydat) (h : c.poprzednieKadencje = 2) :
    ¬ dopuszczalny c := by
  intro d
  have := d.2.2.2.2
  omega

/-- Art. 127 ust. 3: 99 999 podpisów nie wystarcza. -/
theorem wymagane_podpisy (c : Kandydat) (h : c.podpisy = 99999) : ¬ dopuszczalny c := by
  intro d
  have := d.2.2.2.1
  omega

theorem głosy_w_sumie (g : Nat → Nat) {a : Nat} {l : List Nat} (h : a ∈ l) :
    g a ≤ suma g l := by
  induction l with
  | nil => cases h
  | cons x r ih =>
    simp only [suma]
    cases h with
    | head => omega
    | tail _ m =>
      have := ih m
      omega

theorem dwa_w_sumie (g : Nat → Nat) {a b : Nat} {l : List Nat} (n : l.Nodup) (r : a ≠ b)
    (ha : a ∈ l) (hb : b ∈ l) : g a + g b ≤ suma g l := by
  induction l with
  | nil => cases ha
  | cons x t ih =>
    simp only [suma]
    have nx : x ∉ t ∧ t.Nodup := by simpa [List.nodup_cons] using n
    cases ha with
    | head =>
      cases hb with
      | head => exact absurd rfl r
      | tail _ m =>
        have := głosy_w_sumie g m
        omega
    | tail _ ma =>
      cases hb with
      | head =>
        have := głosy_w_sumie g ma
        omega
      | tail _ mb =>
        have := ih nx.2 ma mb
        omega

/-- Art. 127 ust. 4: dwóch kandydatów nie może naraz mieć ponad połowy głosów. -/
theorem jeden_zwycięzca {a b : Nat} (ha : a ∈ Z.kandydaci) (hb : b ∈ Z.kandydaci)
    (wa : większośćI Z a) (wb : większośćI Z b) : a = b := by
  by_cases r : a = b
  · exact r
  · have := dwa_w_sumie Z.głosyI Z.bezPowtórzeń r ha hb
    simp only [większośćI] at wa wb
    omega

/-- Niezmiennik: w grze są tylko zarejestrowani kandydaci. -/
def zListy (Z : Założenia) (s : Stan) : Prop :=
  match s.etap with
  | .drugaTura a b => a ∈ Z.kandydaci ∧ b ∈ Z.kandydaci
  | .ważność w | .objęcie w | .prezydentWybrany w => w ∈ Z.kandydaci
  | _ => True

theorem zawsze_z_listy {s} (h : Osiągalny Z s) : zListy Z s := by
  induction h with
  | start => simp [zListy]
  | krok _ k ih =>
    cases k with
    | zarządzenie => simp [zListy]
    | wygrana v m _ _ => exact m
    | ponowneGłosowanie a b d _ _ => exact ⟨d.1, d.2.1⟩
    | zastąpienieA c m _ _ => exact ⟨m, ih.2⟩
    | zastąpienieB c m _ _ => exact ⟨ih.1, m⟩
    | wygranaA => exact ih.1
    | wygranaB => exact ih.2
    | wybórWażny => exact ih
    | wybórUznanyZaNieważny => simp [zListy]
    | objęcieUrzędu => exact ih

/-- Art. 127 ust. 2–3: wybrany Prezydent spełnia warunki kandydowania. -/
theorem wybrany_dopuszczalny {s w} (h : Osiągalny Z s) (e : s.etap = .prezydentWybrany w) :
    dopuszczalny (Z.dane w) := by
  obtain ⟨u, t, p⟩ := s
  simp only at e
  subst e
  exact Z.wszyscyDopuszczalni w (zawsze_z_listy h)

/-! ## Terminy -/

/-- Art. 128 ust. 2: w trybie zwykłym wybory wypadają 75–100 dni przed końcem kadencji. -/
theorem data_zwykłych {k t z d p}
    (h : Krok Z ⟨.przedZarządzeniem (.zwykły k), t, p⟩ ⟨.pierwszaTura d, z, p⟩) :
    k ≤ d + 100 ∧ d + 75 ≤ k := by
  cases h with
  | zarządzenie _ w _ => exact w.2.2.2

/-- Zarządzenie nie cofa czasu w żadnym trybie. -/
theorem zarządzenie_nie_cofa {m t z d p}
    (h : Krok Z ⟨.przedZarządzeniem m, t, p⟩ ⟨.pierwszaTura d, z, p⟩) : t ≤ z := by
  cases h with
  | zarządzenie _ w _ => exact w.1

/-- W osiągalnych stanach dzień pierwszej tury nie leży przed dniem zarządzenia. -/
theorem tura_po_zarządzeniu {s d} (h : Osiągalny Z s) (e : s.etap = .pierwszaTura d) :
    s.dzień ≤ d := by
  cases h with
  | start => cases e
  | krok _ k =>
    cases k with
    | zarządzenie _ w _ => cases e; exact w.2.1
    | _ => cases e

/-- Czas nigdy nie cofa się w osiągalnych przebiegach. -/
theorem czas_nie_cofa {a b} (h : Osiągalny Z a) (k : Krok Z a b) : a.dzień ≤ b.dzień := by
  cases k with
  | zarządzenie _ w _ => exact w.1
  | wygrana => exact tura_po_zarządzeniu h rfl
  | ponowneGłosowanie =>
    have := tura_po_zarządzeniu h rfl
    simp only at this ⊢
    omega
  | zastąpienieA => simp
  | zastąpienieB => simp
  | wygranaA => exact Nat.le_refl _
  | wygranaB => exact Nat.le_refl _
  | wybórWażny _ l => exact l.1
  | wybórUznanyZaNieważny _ l => exact l.1
  | objęcieUrzędu l => exact l.1

/-- Art. 127 ust. 4 zd. 2: ponowne głosowanie czternastego dnia po pierwszym. -/
theorem druga_tura_czternastego_dnia {z d p s a b}
    (k : Krok Z ⟨.pierwszaTura d, z, p⟩ s) (e : s.etap = .drugaTura a b) :
    s.dzień = d + 14 := by
  cases k with
  | ponowneGłosowanie => rfl
  | wygrana => cases e

/-- Art. 127 ust. 5 zd. 3: zastąpienie kandydata odracza głosowanie o dalsze 14 dni. -/
theorem zastąpienie_odracza_o_14 {t a b p s x y}
    (k : Krok Z ⟨.drugaTura a b, t, p⟩ s) (e : s.etap = .drugaTura x y) :
    s.dzień = t + 14 := by
  cases k with
  | zastąpienieA => rfl
  | zastąpienieB => rfl
  | wygranaA => cases e
  | wygranaB => cases e

/-- Niezmiennik terminów w trybie opróżnienia: dni liczymy od opróżnienia urzędu. -/
def wTerminie (Z : Założenia) (s : Stan) : Prop :=
  s.zapas ≤ Z.zapas ∧ match s.etap with
  | .przedZarządzeniem m => s.dzień = 0 ∧ m = .opróżnienie
  | .pierwszaTura d => s.dzień ≤ 14 ∧ d ≤ 74
  | .drugaTura _ _ | .ważność _ => s.dzień + 14 * s.zapas ≤ 88 + 14 * Z.zapas
  | _ => True

theorem terminy_opróżnienia (m : Z.tryb = .opróżnienie) {s} (h : Osiągalny Z s) :
    wTerminie Z s := by
  induction h with
  | start => simp [wTerminie, m]
  | krok _ k ih =>
    obtain ⟨z, i⟩ := ih
    cases k with
    | zarządzenie _ w _ =>
      obtain ⟨c, e⟩ := i
      subst e
      simp only [terminZarządzenia] at w
      simp only [wTerminie]
      simp only at c z
      omega
    | _ =>
      simp only [wTerminie, wLimicie, wLimicieCzasu] at * <;>
      first
        | omega
        | exact ⟨by omega, trivial⟩

/-- Art. 128 ust. 2: po opróżnieniu pierwsza tura najpóźniej 74. dnia. -/
theorem pierwsza_tura_najpóźniej (m : Z.tryb = .opróżnienie) {d s}
    (h : Osiągalny Z s) (e : s.etap = .pierwszaTura d) : d ≤ 74 := by
  obtain ⟨u, t, p⟩ := s
  simp only at e
  subst e
  exact (terminy_opróżnienia m h).2.2

/-- Art. 127 ust. 4–5: ponowne głosowanie najpóźniej 88. dnia, a każde zastąpienie
kandydata dodaje najwyżej 14 dni. -/
theorem druga_tura_najpóźniej (m : Z.tryb = .opróżnienie) {a b s}
    (h : Osiągalny Z s) (e : s.etap = .drugaTura a b) : s.dzień ≤ 88 + 14 * Z.zapas := by
  obtain ⟨u, t, p⟩ := s
  simp only at e
  subst e
  have : t + 14 * p ≤ 88 + 14 * Z.zapas := (terminy_opróżnienia m h).2
  show t ≤ 88 + 14 * Z.zapas
  omega

/-! ## Blokady -/

/-- Art. 127 ust. 6 nie rozstrzyga remisu: bez zapasu automat staje. -/
theorem remis_blokuje {t a b} (r : Z.głosyII a = Z.głosyII b) (u) :
    ¬ Krok Z ⟨.drugaTura a b, t, 0⟩ u := by
  intro k
  cases k <;> omega

/-- Art. 127 ust. 4 nie opisuje jedynego kandydata bez większości: automat staje. -/
theorem jeden_kandydat_bez_większości {c d z p} (l : Z.kandydaci = [c])
    (g : ¬ większośćI Z c) (u) : ¬ Krok Z ⟨.pierwszaTura d, z, p⟩ u := by
  intro k
  cases k with
  | wygrana w m h _ =>
    rw [l] at m
    cases m with
    | head => exact g h
    | tail _ q => cases q
  | ponowneGłosowanie a b n _ _ =>
    have ma := n.1
    have mb := n.2.1
    rw [l] at ma mb
    cases ma with
    | head =>
      cases mb with
      | head => exact n.2.2.1 rfl
      | tail _ q => cases q
    | tail _ q => cases q

/-- Art. 127 ust. 5 nie opisuje wycofania, gdy nie ma zapasowego kandydata. -/
theorem brak_zapasu_nie_zastępuje {t a b u} (k : Krok Z ⟨.drugaTura a b, t, 0⟩ u) :
    u.etap = .ważność a ∨ u.etap = .ważność b := by
  cases k <;> simp

/-- Art. 228 ust. 7: głosowanie nie odbywa się w okresie ochronnym, więc pierwsza tura
staje, a tekst nie opisuje nowej daty (założenie W6). -/
theorem okres_ochronny_blokuje_turę {d z p} (o : Z.okresOchronny d = true) (u) :
    ¬ Krok Z ⟨.pierwszaTura d, z, p⟩ u := by
  intro k
  cases k with
  | wygrana _ _ _ h => rw [o] at h; cases h
  | ponowneGłosowanie _ _ _ _ h => rw [o] at h; cases h

/-! ## Zakończenie -/

/-- Definicja pomocnicza: zapas zastąpień plus pozostałe etapy. -/
def miara (s : Stan) : Nat := s.zapas + s.etap.ranga

theorem krok_zmniejsza {a b} (k : Krok Z a b) : miara b < miara a := by
  cases k <;> simp only [miara, Etap.ranga] <;> omega

theorem brak_nieskończonego_przebiegu (f : Nat → Stan) :
    ¬ ∀ n, Krok Z (f n) (f (n + 1)) :=
  brak_nieskończonego miara krok_zmniejsza f

structure WarunkiZakończenia (Z : Założenia) : Prop where
  marszałek : Z.marszałekDziała = true
  sąd : Z.sądDziała = true
  dzieńWolny : ∀ t, Z.dzieńWolny t = true
  bezOkresuOchronnego : ∀ t, Z.okresOchronny t = false
  wynikI : (∃ w ∈ Z.kandydaci, większośćI Z w) ∨
    ((∀ k ∈ Z.kandydaci, ¬ większośćI Z k) ∧ ∃ a b, dwajNajlepsi Z a b)
  bezRemisu : ∀ a b, a ≠ b → Z.głosyII a ≠ Z.głosyII b

/-- Warunki art. 127 ust. 5 nie gwarantują `a ≠ b` po zastąpieniu z założenia W4,
dlatego postęp w drugiej turze jest liczony dla różnych kandydatów. -/
theorem postęp (w : WarunkiZakończenia Z) (s : Stan) (n : s.etap.końcowy = false)
    (r : ∀ a b, s.etap = .drugaTura a b → a ≠ b)
    (q : ∀ k, s.etap ≠ .przedZarządzeniem (.zwykły k)) : ∃ u, Krok Z s u := by
  obtain ⟨e, t, p⟩ := s
  have ho := w.bezOkresuOchronnego
  cases e with
  | przedZarządzeniem m =>
    cases m with
    | zwykły k => exact absurd rfl (q k)
    | opróżnienie =>
      refine ⟨⟨.pierwszaTura t, t, p⟩, .zarządzenie w.marszałek ?_ (w.dzieńWolny t)⟩
      simp [terminZarządzenia]
  | pierwszaTura d =>
    rcases w.wynikI with ⟨v, m, h⟩ | ⟨b, a, c, h⟩
    · exact ⟨_, .wygrana v m h (ho d)⟩
    · exact ⟨_, .ponowneGłosowanie a c h b (ho d)⟩
  | drugaTura a b =>
    have ne := r a b rfl
    have := w.bezRemisu a b ne
    by_cases g : Z.głosyII a > Z.głosyII b
    · exact ⟨_, .wygranaA g (ho t)⟩
    · exact ⟨_, .wygranaB (by omega) (ho t)⟩
  | ważność v => exact ⟨_, .wybórWażny w.sąd (refl t)⟩
  | objęcie v => exact ⟨_, .objęcieUrzędu (refl t)⟩
  | prezydentWybrany _ | wybórNieważny => simp [Etap.końcowy] at n

/-- Stany objęte twierdzeniem o zakończeniu: różni kandydaci drugiej tury i brak etapu przed
zarządzeniem wyborów zwykłych, którego daty zależą od końca kadencji. -/
def kandydaciRóżni (s : Stan) : Prop :=
  (∀ a b, s.etap = .drugaTura a b → a ≠ b) ∧ ∀ k, s.etap ≠ .przedZarządzeniem (.zwykły k)

theorem krok_zachowuje_różnych {a b} (k : Krok Z a b) (h : kandydaciRóżni a) :
    kandydaciRóżni b := by
  refine ⟨fun x y e => ?_, fun m e => ?_⟩
  · cases k with
    | ponowneGłosowanie p q d _ _ => cases e; exact d.2.2.1
    | zastąpienieA c _ ca cb => cases e; exact cb
    | zastąpienieB c _ ca cb => cases e; exact fun q => ca q.symm
    | _ => cases e
  · cases k <;> cases e

/-- Krok w obrębie stanów z różnymi kandydatami drugiej tury. -/
def KrokRóżnych (Z : Założenia) (a b : {s : Stan // kandydaciRóżni s}) : Prop :=
  Krok Z a.1 b.1

/-- Przy jawnych warunkach z każdego stanu z różnymi kandydatami prowadzi przebieg
do wyboru albo do stwierdzenia nieważności. -/
theorem zakończenie (w : WarunkiZakończenia Z) (s : Stan) (h : kandydaciRóżni s) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.końcowy = true := by
  obtain ⟨u, p, k⟩ := dojście_do_końca (R := KrokRóżnych Z) (fun s => miara s.1)
    (fun s => s.1.etap.końcowy = true) (fun r => krok_zmniejsza r)
    (fun s n => by
      obtain ⟨u, ku⟩ := postęp w s.1 (by simpa using n) s.2.1 s.2.2
      exact ⟨⟨u, krok_zachowuje_różnych ku s.2⟩, ku⟩) ⟨s, h⟩
  exact ⟨u.1, Przebieg.przenieś (Subtype.val) (fun r => r) p, k⟩

end Konstytucja.WybórPrezydenta
