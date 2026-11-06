import Konstytucja.Procedury.OgłoszenieOrzeczenia

/-! # Własności ogłoszenia orzeczenia -/

namespace Konstytucja.OgłoszenieOrzeczenia

variable {Z : Założenia}

/-- Art. 190 ust. 3 zd. 1: bez ogłoszenia orzeczenie nie wchodzi w życie, a tekst nie podaje
skutku nieogłoszenia. Stan jest osiągalny. -/
theorem nieogłoszenie_blokuje (p : Z.ogłaszającyDziała = false) (a : RodzajAktu) (w : Wynik) :
    Osiągalny Z a w ⟨.wydane, 0, a, w⟩ ∧ ∀ u, ¬ Krok Z ⟨.wydane, 0, a, w⟩ u := by
  refine ⟨.start, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 190 ust. 3 zd. 1: orzeczenie wchodzi w życie tylko przez ogłoszenie. -/
theorem wejście_tylko_przez_ogłoszenie {s u} (k : Krok Z s u) :
    Z.ogłaszającyDziała = true ∧ s.etap = .wydane := by
  cases k <;> exact ⟨by assumption, rfl⟩

/-- Ogłoszenie niezgodności jest osiągalne i daje datę utraty mocy. -/
theorem ogłoszenie_niezgodności_osiągalne (p : Z.ogłaszającyDziała = true) (a : RodzajAktu) :
    ∃ u k, Osiągalny Z a .niezgodność u ∧ u.etap = .wŻyciu (some k) :=
  ⟨_, _, .krok .start (.ogłoszenie (t' := 0) p (Nat.le_refl _) (Nat.zero_le _)), rfl⟩

/-- Ogłoszenie zgodności jest osiągalne i nie daje utraty mocy. -/
theorem ogłoszenie_zgodności_osiągalne (p : Z.ogłaszającyDziała = true) (a : RodzajAktu) :
    ∃ u, Osiągalny Z a .zgodność u ∧ u.etap = .wŻyciu none :=
  ⟨_, .krok .start (.ogłoszenieZgodności (t' := 0) p (Nat.le_refl _) (Nat.zero_le _)), rfl⟩

/-- Tylko orzeczenie o niezgodności prowadzi do utraty mocy aktu. -/
theorem zgodność_bez_utraty_mocy {t a s k}
    (h : Krok Z ⟨.wydane, t, a, .zgodność⟩ s) (e : s.etap = .wŻyciu (some k)) : False := by
  cases h
  cases e

/-- Art. 190 ust. 3 zd. 2: odroczenie mieści się w 18 miesiącach dla ustawy. -/
theorem odroczenie_ustawy {t t' k}
    (h : Krok Z ⟨.wydane, t, .ustawa, .niezgodność⟩ ⟨.wŻyciu (some k), t', .ustawa, .niezgodność⟩)
    (o : t' < k) : k ≤ Z.kalendarz.poMiesiącach t' 18 := by
  cases h with
  | ogłoszenie => omega
  | ogłoszenieZOdroczeniem _ _ _ _ m => exact m

/-- Art. 190 ust. 3 zd. 2: dla innego aktu limit wynosi 12 miesięcy. -/
theorem odroczenie_innego_aktu {t t' k}
    (h : Krok Z ⟨.wydane, t, .innyAkt, .niezgodność⟩
      ⟨.wŻyciu (some k), t', .innyAkt, .niezgodność⟩) (o : t' < k) :
    k ≤ Z.kalendarz.poMiesiącach t' 12 := by
  cases h with
  | ogłoszenie => omega
  | ogłoszenieZOdroczeniem _ _ _ _ m => exact m

end Konstytucja.OgłoszenieOrzeczenia
