import Konstytucja.Podstawy.Normy

/-! # Kolizja art. 155 ust. 2 i art. 228 ust. 7

Art. 155 ust. 2 każe Prezydentowi skrócić kadencję Sejmu po nieudzieleniu wotum zaufania.
Art. 228 ust. 7 zakazuje skrócenia kadencji w czasie stanu nadzwyczajnego i przez 90 dni
po nim. Model pokazuje kolizję i to, że da się ją usunąć w obie strony. Którą regułę
wybrać, jest sprawą wykładni.
-/

namespace Konstytucja

structure SytuacjaKadencji where
  /-- Stan nadzwyczajny lub 90 dni po jego zakończeniu. -/
  okresOchronny : Bool
  /-- Nieudzielone wotum zaufania w trybie art. 155 ust. 1. -/
  brakWotum : Bool

inductive CzynKadencyjny where
  | skrócenieKadencjiSejmu
  deriving DecidableEq

def nakazArt155 : Norma SytuacjaKadencji CzynKadencyjny where
  źródło := { art := 155, ust := 2 }
  modalność := .nakaz
  czyn := .skrócenieKadencjiSejmu
  zakres := fun s => s.brakWotum = true
  wyjątek := fun _ => False

def zakazArt228 : Norma SytuacjaKadencji CzynKadencyjny where
  źródło := { art := 228, ust := 7 }
  modalność := .zakaz
  czyn := .skrócenieKadencjiSejmu
  zakres := fun s => s.okresOchronny = true
  wyjątek := fun _ => False

/-- Przy tej sytuacji obie normy działają i się wykluczają. -/
theorem kolizja_art155_art228 : Kolizja nakazArt155 zakazArt228 ⟨true, true⟩ := by
  simp [Kolizja, Norma.działa, nakazArt155, zakazArt228, Modalność.sprzeczna]

/-- Poza okresem ochronnym albo przy udzielonym wotum kolizji nie ma. -/
theorem kolizja_tylko_gdy_oba_warunki (s : SytuacjaKadencji)
    (h : Kolizja nakazArt155 zakazArt228 s) : s.okresOchronny = true ∧ s.brakWotum = true :=
  ⟨h.2.2.1.1, h.2.1.1⟩

/-- Rozstrzygnięcie na rzecz art. 228 ust. 7. -/
theorem pierwszeństwo_art228 (s) : ¬ Kolizja (nakazArt155.ustępuje zakazArt228) zakazArt228 s :=
  ustąpienie_usuwa_kolizję _ _ s

/-- Rozstrzygnięcie na rzecz art. 155 ust. 2 też jest niesprzeczne. -/
theorem pierwszeństwo_art155 (s) : ¬ Kolizja (zakazArt228.ustępuje nakazArt155) nakazArt155 s :=
  ustąpienie_usuwa_kolizję _ _ s

/-! # Kolizja art. 155 ust. 2 i art. 131 ust. 4

Art. 131 ust. 4 zabrania osobie wykonującej obowiązki Prezydenta postanowić o skróceniu
kadencji Sejmu, a art. 155 ust. 2 nakazuje Prezydentowi skrócić kadencję. Tekst nie mówi,
kto wtedy działa ani czy obowiązek przechodzi na zastępcę.
-/

structure SytuacjaZastępstwa where
  /-- Obowiązki wykonuje Marszałek. -/
  zastępstwo : Bool
  brakWotum : Bool

/-- Przy założeniu, że obowiązek z art. 155 ust. 2 przechodzi na osobę wykonującą obowiązki. -/
def nakazArt155PrzyZastępstwie : Norma SytuacjaZastępstwa CzynKadencyjny where
  źródło := { art := 155, ust := 2 }
  modalność := .nakaz
  czyn := .skrócenieKadencjiSejmu
  zakres := fun s => s.brakWotum = true
  wyjątek := fun _ => False

def zakazArt131 : Norma SytuacjaZastępstwa CzynKadencyjny where
  źródło := { art := 131, ust := 4 }
  modalność := .zakaz
  czyn := .skrócenieKadencjiSejmu
  zakres := fun s => s.zastępstwo = true
  wyjątek := fun _ => False

theorem kolizja_art155_art131 :
    Kolizja nakazArt155PrzyZastępstwie zakazArt131 ⟨true, true⟩ := by
  simp [Kolizja, Norma.działa, nakazArt155PrzyZastępstwie, zakazArt131, Modalność.sprzeczna]

/-- Bez zastępstwa art. 131 ust. 4 nie działa. -/
theorem bez_zastępstwa_brak_kolizji (s : SytuacjaZastępstwa) (z : s.zastępstwo = false) :
    ¬ Kolizja nakazArt155PrzyZastępstwie zakazArt131 s := by
  intro h
  have := h.2.2.1.1
  simp only [zakazArt131] at this
  rw [z] at this
  cases this

end Konstytucja
