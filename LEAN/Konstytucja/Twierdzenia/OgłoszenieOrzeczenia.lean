import Konstytucja.Procedury.OgłoszenieOrzeczenia

/-! # Własności ogłoszenia orzeczenia -/

namespace Konstytucja.OgłoszenieOrzeczenia

variable {Z : Założenia}

/-- Art. 190 ust. 3 zd. 1: bez ogłoszenia orzeczenie nie wchodzi w życie, a tekst nie podaje
skutku nieogłoszenia. Stan jest osiągalny. -/
theorem nieogłoszenie_blokuje (p : Z.ogłaszającyDziała = false) (a : RodzajAktu) :
    Osiągalny Z a ⟨.wydane, 0, a⟩ ∧ ∀ u, ¬ Krok Z ⟨.wydane, 0, a⟩ u := by
  refine ⟨.start, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 190 ust. 3 zd. 1: wejście w życie następuje najpóźniej w czasie ogłoszenia. -/
theorem wejście_tylko_przez_ogłoszenie {s u} (k : Krok Z s u) : Z.ogłaszającyDziała = true := by
  cases k <;> assumption

/-- Ogłoszenie jest osiągalne. -/
theorem ogłoszenie_osiągalne (p : Z.ogłaszającyDziała = true) (a : RodzajAktu) :
    ∃ u, Osiągalny Z a u ∧ u.dzień = 0 :=
  ⟨_, .krok .start (.ogłoszenie (t' := 0) p (Nat.le_refl _) (Nat.zero_le _)), rfl⟩

/-- Art. 190 ust. 3 zd. 2: odroczenie mieści się w 18 miesiącach dla ustawy. -/
theorem odroczenie_ustawy {t t' k} (h : Krok Z ⟨.wydane, t, .ustawa⟩ ⟨.wŻyciu k, t', .ustawa⟩)
    (o : t' < k) : k ≤ Z.kalendarz.poMiesiącach t' 18 := by
  cases h with
  | ogłoszenie => omega
  | ogłoszenieZOdroczeniem _ _ _ _ m => exact m

/-- Art. 190 ust. 3 zd. 2: dla innego aktu limit wynosi 12 miesięcy. -/
theorem odroczenie_innego_aktu {t t' k}
    (h : Krok Z ⟨.wydane, t, .innyAkt⟩ ⟨.wŻyciu k, t', .innyAkt⟩) (o : t' < k) :
    k ≤ Z.kalendarz.poMiesiącach t' 12 := by
  cases h with
  | ogłoszenie => omega
  | ogłoszenieZOdroczeniem _ _ _ _ m => exact m

end Konstytucja.OgłoszenieOrzeczenia
