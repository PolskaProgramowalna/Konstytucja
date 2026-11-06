import Konstytucja.Podstawy.Interpretacja

/-! # Zależność wyników od interpretacji -/

namespace Konstytucja

/-- T8: to samo ograniczenie może być dopuszczalne przy jednej interpretacji
art. 31 ust. 3 i niedopuszczalne przy innej. -/
theorem dwie_interpretacje (o : Ograniczenie) (h : o.wUstawie = true) :
    ∃ I₁ I₂ : Interpretacja, dopuszczalne I₁ o ∧ ¬ dopuszczalne I₂ o :=
  ⟨⟨fun _ => True, fun _ => False, fun _ => True⟩,
   ⟨fun _ => False, fun _ => False, fun _ => True⟩,
   ⟨h, trivial, id⟩, fun h' => h'.2.1⟩

/-- Ograniczenie poza ustawą jest niedopuszczalne przy każdej interpretacji. -/
theorem bez_ustawy_niedopuszczalne (I : Interpretacja) (o : Ograniczenie)
    (h : o.wUstawie = false) : ¬ dopuszczalne I o := fun ⟨u, _⟩ => by
  rw [h] at u
  exact Bool.noConfusion u

end Konstytucja
