/-! # Art. 144: kontrasygnata

Założenia K1–K3 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.Kontrasygnata

/-- Art. 144 ust. 3. Kolejność konstruktorów odpowiada punktom przepisu. -/
inductive Prerogatywa where
  | zarządzanieWyborówDoSejmuISenatu
  | zwoływaniePierwszegoPosiedzenia
  | skracanieKadencjiSejmu
  | inicjatywaUstawodawcza
  | zarządzanieReferendum
  | podpisywanieAlboOdmowaPodpisania
  | zarządzanieOgłoszenia
  | orędzie
  | wniosekDoTrybunałuKonstytucyjnego
  | wniosekOKontrolęNIK
  | desygnowanieIPowoływaniePrezesaRM
  | przyjmowanieDymisjiRady
  | wniosekOTrybunałStanu
  | odwoływanieMinistraPoWotum
  | zwoływanieRadyGabinetowej
  | nadawanieOrderów
  | powoływanieSędziów
  | prawoŁaski
  | obywatelstwo
  | powoływaniePierwszegoPrezesaSN
  | powoływaniePrezesaIWiceprezesaTK
  | powoływaniePrezesaNSA
  | powoływaniePrezesówSNIWiceprezesówNSA
  | wniosekOPowołaniePrezesaNBP
  | powoływanieCzłonkówRPP
  | członkowieRadyBezpieczeństwaNarodowego
  | członkowieKRRiT
  | kancelariaPrezydenta
  | zarządzenia
  | zrzeczenieSięUrzędu
  deriving DecidableEq, Repr

open Prerogatywa

/-- Numer punktu w art. 144 ust. 3. -/
def Prerogatywa.punkt : Prerogatywa → Nat
  | zarządzanieWyborówDoSejmuISenatu => 1
  | zwoływaniePierwszegoPosiedzenia => 2
  | skracanieKadencjiSejmu => 3
  | inicjatywaUstawodawcza => 4
  | zarządzanieReferendum => 5
  | podpisywanieAlboOdmowaPodpisania => 6
  | zarządzanieOgłoszenia => 7
  | orędzie => 8
  | wniosekDoTrybunałuKonstytucyjnego => 9
  | wniosekOKontrolęNIK => 10
  | desygnowanieIPowoływaniePrezesaRM => 11
  | przyjmowanieDymisjiRady => 12
  | wniosekOTrybunałStanu => 13
  | odwoływanieMinistraPoWotum => 14
  | zwoływanieRadyGabinetowej => 15
  | nadawanieOrderów => 16
  | powoływanieSędziów => 17
  | prawoŁaski => 18
  | obywatelstwo => 19
  | powoływaniePierwszegoPrezesaSN => 20
  | powoływaniePrezesaIWiceprezesaTK => 21
  | powoływaniePrezesaNSA => 22
  | powoływaniePrezesówSNIWiceprezesówNSA => 23
  | wniosekOPowołaniePrezesaNBP => 24
  | powoływanieCzłonkówRPP => 25
  | członkowieRadyBezpieczeństwaNarodowego => 26
  | członkowieKRRiT => 27
  | kancelariaPrezydenta => 28
  | zarządzenia => 29
  | zrzeczenieSięUrzędu => 30

/-- Wszystkie punkty art. 144 ust. 3. -/
def wszystkie : List Prerogatywa :=
  [zarządzanieWyborówDoSejmuISenatu, zwoływaniePierwszegoPosiedzenia, skracanieKadencjiSejmu,
   inicjatywaUstawodawcza, zarządzanieReferendum, podpisywanieAlboOdmowaPodpisania,
   zarządzanieOgłoszenia, orędzie, wniosekDoTrybunałuKonstytucyjnego, wniosekOKontrolęNIK,
   desygnowanieIPowoływaniePrezesaRM, przyjmowanieDymisjiRady, wniosekOTrybunałStanu,
   odwoływanieMinistraPoWotum, zwoływanieRadyGabinetowej, nadawanieOrderów, powoływanieSędziów,
   prawoŁaski, obywatelstwo, powoływaniePierwszegoPrezesaSN, powoływaniePrezesaIWiceprezesaTK,
   powoływaniePrezesaNSA, powoływaniePrezesówSNIWiceprezesówNSA, wniosekOPowołaniePrezesaNBP,
   powoływanieCzłonkówRPP, członkowieRadyBezpieczeństwaNarodowego, członkowieKRRiT,
   kancelariaPrezydenta, zarządzenia, zrzeczenieSięUrzędu]

/-- Akt urzędowy Prezydenta (art. 144 ust. 1). -/
inductive Akt where
  | prerogatywa (p : Prerogatywa)
  /-- Art. 122 ust. 5, założenie K1. -/
  | wniosekOPonowneRozpatrzenie
  /-- Art. 133 ust. 1 pkt 1. -/
  | ratyfikacjaUmowy
  /-- Art. 133 ust. 1 pkt 2. -/
  | mianowaniePrzedstawiciela
  /-- Art. 134 ust. 3–4. -/
  | mianowanieDowódców
  /-- Art. 142 ust. 1. -/
  | rozporządzenie
  /-- Art. 229. -/
  | wprowadzenieStanuWojennego
  /-- Art. 230 ust. 1. -/
  | wprowadzenieStanuWyjątkowego
  /-- Każdy inny akt urzędowy, założenie K2. -/
  | inny
  deriving DecidableEq, Repr

/-- Art. 144 ust. 2–3, założenia K1 i K2. -/
def wymagaKontrasygnaty (wetoWolneOdKontrasygnaty : Bool) : Akt → Bool
  | .prerogatywa _ => false
  | .wniosekOPonowneRozpatrzenie => !wetoWolneOdKontrasygnaty
  | _ => true

/-- Art. 144 ust. 2: ważność aktu. -/
def ważny (w : Bool) (a : Akt) (podpisPrezesa : Bool) : Bool :=
  !wymagaKontrasygnaty w a || podpisPrezesa

end Konstytucja.Kontrasygnata
