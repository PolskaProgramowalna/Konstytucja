import Konstytucja.Procedury.UrządPrezydenta
import Konstytucja.Twierdzenia.WybórPrezydenta

/-! # Własności ciągłości urzędu Prezydenta -/

namespace Konstytucja.UrządPrezydenta

open Konstytucja

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

private def pełne : Głosowanie .zgromadzenieNarodowe := ⟨560, 0, 0, by decide⟩

private theorem pełne_uchwala : uchwałaZgromadzeniaArt145 pełne := by
  simp [uchwałaZgromadzeniaArt145, ułamekUstawowejLiczby, pełne, Izba.ustawowaLiczba]

private theorem pełne_oskarża : stanOskarżenia 140 pełne := ⟨by decide, pełne_uchwala⟩

/-! ## Osiągalność -/

theorem do_niemożności : Osiągalny Z ⟨.przejściowaNiemożność, 0, zastępca Z⟩ :=
  .krok .start .zawiadomienie

theorem śmierć_opróżnia : ∃ u, Osiągalny Z u ∧ u.etap = .opróżniony .śmierć :=
  ⟨_, .krok .start .śmierć, rfl⟩

theorem zrzeczenie_opróżnia : ∃ u, Osiągalny Z u ∧ u.etap = .opróżniony .zrzeczenie :=
  ⟨_, .krok .start .zrzeczenie, rfl⟩

theorem niezdolność_opróżnia :
    ∃ u, Osiągalny Z u ∧ u.etap = .opróżniony .trwałaNiezdolność :=
  ⟨_, .krok do_niemożności (.niezdolność pełne pełne_uchwala), rfl⟩

theorem do_zawieszenia : Osiągalny Z ⟨.zawieszony, 0, zastępca Z⟩ :=
  .krok .start (.zawieszenie 140 pełne pełne_oskarża)

theorem złożenie_opróżnia (t : Z.trybunałStanuOrzeka = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .opróżniony .złożenieZUrzędu :=
  ⟨_, .krok do_zawieszenia (.złożenie t (refl 0)), rfl⟩

theorem powrót_po_niemożności :
    ∃ u, Osiągalny Z u ∧ u.etap = .sprawuje ∧ u.wykonujący = .prezydent :=
  ⟨_, .krok do_niemożności (.powrót (refl 0)), rfl, rfl⟩

theorem trybunał_może_uznać (t : Z.trybunałOrzeka = true) :
    Osiągalny Z ⟨.przejściowaNiemożność, 0, zastępca Z⟩ :=
  .krok (.krok .start .wniosekMarszałka) (.trybunałUznaje t (refl 0))

/-! ## Ograniczenia -/

/-- Niezmiennik: obowiązki zawsze wykonuje właściwa osoba. -/
def właściwaOsoba (Z : Założenia) (s : Stan) : Prop :=
  match s.etap with
  | .sprawuje | .wniosekDoTrybunału => s.wykonujący = .prezydent
  | _ => s.wykonujący = zastępca Z

/-- Art. 126 ust. 1 i art. 131: urząd ma zawsze wykonawcę, a poza sprawowaniem
przez Prezydenta jest nim zastępca z art. 131. -/
theorem zawsze_właściwa_osoba {s} (h : Osiągalny Z s) : właściwaOsoba Z s := by
  induction h with
  | start => rfl
  | krok _ k ih => cases k <;> rfl

theorem zastępca_nie_prezydent : zastępca Z ≠ .prezydent := by
  simp only [zastępca]
  split <;> simp

/-- Art. 131 ust. 3: Marszałek Senatu tylko wtedy, gdy Marszałek Sejmu nie może. -/
theorem marszałek_senatu_tylko_w_zastępstwie {s} (h : Osiągalny Z s)
    (e : s.wykonujący = .marszałekSenatu) : Z.marszałekSejmuMoże = false := by
  have i := zawsze_właściwa_osoba h
  obtain ⟨u, t, o⟩ := s
  simp only at e
  subst e
  cases u <;> simp [właściwaOsoba, zastępca] at i <;> simp_all

/-- Art. 131 ust. 2–3: gdy Marszałek Sejmu może działać, to on zastępuje. -/
theorem marszałek_sejmu_pierwszy (m : Z.marszałekSejmuMoże = true) :
    zastępca Z = .marszałekSejmu := by
  simp [zastępca, m]

/-- Art. 145 ust. 2: wniosek 140 członków i 374 głosy Zgromadzenia Narodowego. -/
theorem oskarżenie_wymaga {n g} (h : stanOskarżenia n g) : n ≥ 140 ∧ g.za ≥ 374 :=
  ⟨h.1, min_art145.2 g h.2⟩

/-- Art. 131 ust. 2 pkt 5: złożenie z urzędu tylko po zawieszeniu i orzeczeniu. -/
theorem złożenie_tylko_po_zawieszeniu {a b} (k : Krok Z a b)
    (e : b.etap = .opróżniony .złożenieZUrzędu) :
    a.etap = .zawieszony ∧ Z.trybunałStanuOrzeka = true := by
  cases k with
  | złożenie h _ => exact ⟨rfl, h⟩
  | _ => cases e

/-- Art. 131 ust. 2 pkt 4: trwała niezdolność wymaga uchwały Zgromadzenia Narodowego. -/
theorem niezdolność_wymaga_uchwały {a b} (k : Krok Z a b)
    (e : b.etap = .opróżniony .trwałaNiezdolność) : ∃ g, uchwałaZgromadzeniaArt145 g := by
  cases k with
  | niezdolność g h => exact ⟨g, h⟩
  | _ => cases e

/-! ## Blokady -/

/-- Art. 131 ust. 1 nie podaje terminu Trybunałowi. -/
theorem brak_orzeczenia_trybunału_blokuje (t : Z.trybunałOrzeka = false) :
    Osiągalny Z ⟨.wniosekDoTrybunału, 0, .prezydent⟩ ∧
      ∀ u, ¬ Krok Z ⟨.wniosekDoTrybunału, 0, .prezydent⟩ u := by
  refine ⟨.krok .start .wniosekMarszałka, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 145 nie podaje terminu Trybunałowi Stanu: zawieszenie może trwać bez końca. -/
theorem brak_orzeczenia_stanu_blokuje (t : Z.trybunałStanuOrzeka = false) :
    Osiągalny Z ⟨.zawieszony, 0, zastępca Z⟩ ∧ ∀ u, ¬ Krok Z ⟨.zawieszony, 0, zastępca Z⟩ u := by
  refine ⟨do_zawieszenia, fun u k => ?_⟩
  cases k <;> simp_all

/-! ## Złożenie z automatem wyboru -/

variable {W : WybórPrezydenta.Założenia}

/-- Art. 128 ust. 2: po opróżnieniu urzędu, przy warunkach wyboru, prowadzi przebieg do
wyboru Prezydenta albo do stwierdzenia nieważności. -/
theorem opróżnienie_prowadzi_do_wyników (w : WybórPrezydenta.WarunkiZakończenia W)
    (t o p) : ∃ u, Przebieg (PełnyKrok Z W) (.inl ⟨.opróżniony p, t, o⟩) (.inr u) ∧
      u.etap.końcowy = true := by
  obtain ⟨u, q, k⟩ := WybórPrezydenta.zakończenie w ⟨.przedZarządzeniem, t, W.zapas⟩
    (fun _ _ e => by cases e)
  exact ⟨u, .dalej .opróżnienie (Przebieg.przenieś Sum.inr (fun r => .wybór r) q), k⟩

/-- Art. 129 ust. 3: nieważny wybór wraca do zarządzenia, a tekst nie ogranicza powtórzeń. -/
theorem nieważność_wraca_do_zarządzenia (t p) :
    PełnyKrok Z W (.inr ⟨.wybórNieważny, t, p⟩) (.inr ⟨.przedZarządzeniem, t, W.zapas⟩) :=
  .ponowneWybory

/-- Pełny obieg: urząd zostaje opróżniony, wybrany obejmuje urząd i Prezydent sprawuje go. -/
theorem wybrany_obejmuje (w : Nat) (t p) :
    PełnyKrok Z W (.inr ⟨.prezydentWybrany w, t, p⟩) (.inl ⟨.sprawuje, t, .prezydent⟩) :=
  .objęcie

end Konstytucja.UrządPrezydenta
