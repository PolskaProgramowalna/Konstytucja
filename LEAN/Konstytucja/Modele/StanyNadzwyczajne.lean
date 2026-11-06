import Konstytucja.Modele.Wybory
import Konstytucja.Modele.Procedury
import Konstytucja.Twierdzenia.StanyNadzwyczajne

/-! # Stany nadzwyczajne a inne procedury

Jedna historia stanów zasila pozostałe automaty, zamiast osobnych parametrów. Daty są
przykładowe.
-/

namespace Konstytucja.Modele

open StanyNadzwyczajne

variable (h : Historia)

/-- Zmiana Konstytucji przy danej historii stanów. -/
def zmianaPrzyHistorii : ZmianaKonstytucji.Założenia :=
  { zmianaChroniona with
    stanNadzwyczajny := wStanie h
    okresOchronny := wOkresieOchronnym h
    stanWOkresie := stan_w_okresie h }

def referendumPrzyHistorii : Referendum.Założenia :=
  { referendumWedługTekstu with okresOchronny := wOkresieOchronnym h }

def wyboryPrzyHistorii : WybórPrezydenta.Założenia :=
  { wyboryJednejTury with okresOchronny := wOkresieOchronnym h }

def rządPrzyHistorii : TworzenieRządu.Założenia :=
  { rządWedługTekstu with okresOchronny := wOkresieOchronnym h }

variable {h}

/-- Art. 228 ust. 6: podpis zmiany Konstytucji tylko poza stanem z historii. -/
theorem podpis_poza_historią {a b} (k : ZmianaKonstytucji.Krok (zmianaPrzyHistorii h) a b)
    (e : b.etap = .podpisana) : wStanie h b.dzień = false :=
  ZmianaKonstytucji.podpis_poza_stanem k e

/-- Art. 228 ust. 7: głosowanie w referendum tylko poza okresem z historii. -/
theorem głosowanie_poza_historią {a b w} (k : Referendum.Krok (referendumPrzyHistorii h) a b)
    (e : b.etap = .ważność w) : wOkresieOchronnym h b.dzień = false :=
  Referendum.głosowanie_poza_okresem k e

/-- Art. 228 ust. 7: tura wyborów nie odbywa się w okresie z historii. -/
theorem tura_poza_historią {d z p} (o : wOkresieOchronnym h d = true) (u) :
    ¬ WybórPrezydenta.Krok (wyboryPrzyHistorii h) ⟨.pierwszaTura d, z, p⟩ u :=
  WybórPrezydenta.okres_ochronny_blokuje_turę o u

/-- Art. 228 ust. 7: skrócenie kadencji tylko poza okresem z historii. -/
theorem skrócenie_poza_historią {s t}
    (k : TworzenieRządu.Krok (rządPrzyHistorii h) s ⟨.kadencjaSkrócona, t⟩) :
    wOkresieOchronnym h t = false :=
  TworzenieRządu.skrócenie_poza_okresem_ochronnym rfl k

/-- Przykładowy stan od dnia 100 do dnia 130. -/
def historiaPrzykładowa : Historia := [(100, 130)]

theorem granice_przykładu :
    wStanie historiaPrzykładowa 99 = false ∧ wStanie historiaPrzykładowa 120 = true ∧
    wStanie historiaPrzykładowa 131 = false ∧ wOkresieOchronnym historiaPrzykładowa 131 = true ∧
    wOkresieOchronnym historiaPrzykładowa 220 = true ∧
    wOkresieOchronnym historiaPrzykładowa 221 = false := by decide

/-- Między końcem stanu a 90. dniem po nim można już podpisać zmianę Konstytucji, ale nie
można przeprowadzić referendum, wyborów ani skrócić kadencji. -/
theorem okres_przejściowy (t : Nat) (a : 131 ≤ t) (b : t ≤ 220) :
    wStanie historiaPrzykładowa t = false ∧ wOkresieOchronnym historiaPrzykładowa t = true := by
  simp [wStanie, wOkresieOchronnym, historiaPrzykładowa]
  omega

/-- Założenie S7 w przykładzie: kadencja kończąca się 120. dnia trwa do dnia 221. -/
theorem kadencja_w_przykładzie : przedłużonaKadencja historiaPrzykładowa 120 = 221 := by decide

end Konstytucja.Modele
