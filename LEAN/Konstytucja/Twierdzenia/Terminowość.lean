import Konstytucja.Twierdzenia.SystemNorm
import Konstytucja.Modele.StanyNadzwyczajne

/-! # Wykonalność terminowa

Założenie F4. Statyczny system norm opisuje jeden moment, a obowiązki mają terminy. Tu
obowiązek jest wykonalny, jeśli w jego oknie istnieje dzień, w którym zakaz nie działa.
Zakaz pochodzi z tej samej historii stanów co automaty.
-/

namespace Konstytucja.Terminowość

open StanyNadzwyczajne Modele

/-- Istnieje dzień w oknie `[start, start + okno]`, w którym zakaz nie działa. -/
def WykonalnyWTerminie (zakaz : Nat → Bool) (start okno : Nat) : Prop :=
  ∃ d, start ≤ d ∧ d ≤ start + okno ∧ zakaz d = false

/-- Art. 128 ust. 2 po opróżnieniu urzędu: 14 + 60 dni (F4). -/
def oknoWyborów : Nat := 74

/-- Art. 235 ust. 6: referendum w ciągu 60 dni od wniosku. -/
def oknoReferendum : Nat := 60

/-- Art. 235 ust. 7: podpis w ciągu 21 dni. -/
def oknoPodpisu : Nat := 21

/-- Zakaz bez końca wyklucza obowiązek tylko wtedy, gdy obejmuje całe okno. -/
theorem niewykonalny_iff (zakaz : Nat → Bool) (start okno : Nat) :
    ¬ WykonalnyWTerminie zakaz start okno ↔
      ∀ d, start ≤ d → d ≤ start + okno → zakaz d = true := by
  constructor
  · intro n d a b
    cases q : zakaz d with
    | true => rfl
    | false => exact absurd ⟨d, a, b, q⟩ n
  · rintro h ⟨d, a, b, q⟩
    rw [h d a b] at q
    cases q

/-- Art. 128 ust. 2: urząd opróżnia się w dniu 95, ochrona kończy się w dniu 100, a wybory
mogą się odbyć w dniu 101. Sytuacja jest statycznie sprzeczna, lecz terminowo wykonalna. -/
theorem wybory_po_okresie_wykonalne :
    WykonalnyWTerminie (wOkresieOchronnym [(0, 10)]) 95 oknoWyborów := by
  exact ⟨101, by decide, by decide, by decide⟩

/-- Automat wyboru dopuszcza dokładnie ten scenariusz. -/
theorem automat_potwierdza_scenariusz (p) :
    WybórPrezydenta.Krok (wyboryPrzyHistorii [(0, 10)])
        ⟨.przedZarządzeniem .opróżnienie, 95, p⟩ ⟨.pierwszaTura 101, 95, p⟩ ∧
      WybórPrezydenta.Krok (wyboryPrzyHistorii [(0, 10)])
        ⟨.pierwszaTura 101, 95, p⟩ ⟨.ważność 0, 101, p⟩ := by
  constructor
  · exact .zarządzenie rfl (by simp [WybórPrezydenta.terminZarządzenia]) rfl
  · exact .wygrana 0 (by simp [wyboryPrzyHistorii, wyboryJednejTury])
      (by simp [WybórPrezydenta.większośćI, wyboryPrzyHistorii, wyboryJednejTury,
        WybórPrezydenta.suma]) (by decide)

/-- Art. 128 ust. 2: gdy ochrona obejmuje całe okno, obowiązek naprawdę koliduje z zakazem. -/
theorem wybory_niewykonalne_gdy_ochrona_obejmuje_okno :
    ¬ WykonalnyWTerminie (wOkresieOchronnym [(95, 169)]) 95 oknoWyborów := by
  rw [niewykonalny_iff]
  intro d a b
  simp only [oknoWyborów] at b
  simp [wOkresieOchronnym, a]
  omega

/-- Art. 235 ust. 6: to samo dla 60 dni referendum, przy wariancie V5. -/
theorem referendum_zależy_od_okna :
    WykonalnyWTerminie (wOkresieOchronnym [(0, 10)]) 95 oknoReferendum ∧
      ¬ WykonalnyWTerminie (wOkresieOchronnym [(95, 155)]) 95 oknoReferendum := by
  constructor
  · exact ⟨101, by decide, by decide, by decide⟩
  · rw [niewykonalny_iff]
    intro d a b
    simp only [oknoReferendum] at b
    simp [wOkresieOchronnym, a]
    omega

/-- Art. 235 ust. 7 i art. 228 ust. 6: podpis koliduje tylko ze stanem obejmującym 21 dni. -/
theorem podpis_zależy_od_okna :
    WykonalnyWTerminie (wStanie [(0, 10)]) 5 oknoPodpisu ∧
      ¬ WykonalnyWTerminie (wStanie [(5, 26)]) 5 oknoPodpisu := by
  constructor
  · exact ⟨11, by decide, by decide, by decide⟩
  · rw [niewykonalny_iff]
    intro d a b
    simp only [oknoPodpisu] at b
    simp [wStanie, a]
    omega

/-- Art. 155 ust. 2 nie ma terminu: przy skończonej historii kadencję da się skrócić później. -/
theorem skrócenie_bez_terminu_wykonalne (h : Historia) (t : Nat) :
    ∃ d, t ≤ d ∧ wOkresieOchronnym h d = false :=
  ⟨t + koniecOchrony h, by omega, wolne_od_końca_ochrony h (by omega)⟩

end Konstytucja.Terminowość
