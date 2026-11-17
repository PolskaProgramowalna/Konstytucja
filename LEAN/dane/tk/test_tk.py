"""Testy silnika testu ciągłości TK (uruchomienie: python3 tk_test.py testy)."""
from __future__ import annotations

import pathlib
import tempfile
import unittest

from . import lean, model, oceny, parametry, przebieg, rejestr
from .daty import Chwila, Przedział, W3, data, plus_lata
from .model import ZałożeniaDanych
from .parametry import Interpretacja

TU = pathlib.Path(__file__).resolve().parent
REJ = rejestr.wczytaj(TU.parent / "tk_rejestr.csv")

NAGŁÓWEK = "id,typ,data,osoba,wakat,atrybuty,zrodlo,pewnosc,uwagi\n"
SEJM = "S1,SEJM,2000-01-01,,,kadencja=1;do=,API-SEJM:x,ustalone,\n"


def rej_z(tekst: str) -> rejestr.Rejestr:
    with tempfile.NamedTemporaryFile("w", suffix=".csv", delete=False, encoding="utf8") as f:
        f.write(NAGŁÓWEK + SEJM + tekst)
    return rejestr.wczytaj(pathlib.Path(f.name))


class Daty(unittest.TestCase):
    def test_29_lutego(self):
        self.assertEqual(plus_lata(data("2016-02-29"), 9), data("2025-02-28"))

    def test_przedział_półotwarty(self):
        p = Przedział(Chwila.dokładnie(data("2015-11-06")), Chwila.dokładnie(data("2024-11-06")))
        self.assertIs(p.zawiera(data("2015-11-06")), W3.TAK)
        self.assertIs(p.zawiera(data("2024-11-05")), W3.TAK)
        self.assertIs(p.zawiera(data("2024-11-06")), W3.NIE)

    def test_niepewny_koniec(self):
        p = Przedział(Chwila.dokładnie(data("2016-01-01")), Chwila(data("2017-01-01"), None))
        self.assertIs(p.zawiera(data("2016-06-01")), W3.TAK)
        self.assertIs(p.zawiera(data("2018-01-01")), W3.NIEUST)

    def test_logika_trójwartościowa(self):
        self.assertIs(W3.TAK & W3.NIEUST, W3.NIEUST)
        self.assertIs(W3.NIE & W3.NIEUST, W3.NIE)
        self.assertIs(W3.TAK | W3.NIEUST, W3.TAK)
        self.assertIs(~W3.NIEUST, W3.NIEUST)


class Rejestr(unittest.TestCase):
    def test_rejestr_bez_błędów(self):
        self.assertEqual(REJ.błędy, [])

    def test_walidator_wykrywa_błędy(self):
        r = rej_z("A,E1,2010-01-01,x,,poczatek=2010-01-10,ELI:MP/1,ustalone,\n"
                  "A,E2,2010-01-02,x,,forma=wobec_prezydenta,,ustalone,\n"
                  "B,E4,2010-01-03,nieznany,,,DOC:x,ustalone,\n"
                  "C,E1,2011-01-01,y,W.zzz,,ELI:MP/2,pewne,\n")
        tekst = "\n".join(r.błędy)
        self.assertIn("identyfikator powtórzony", tekst)
        self.assertIn("brak źródła", tekst)
        self.assertIn("bez zdarzenia E1", tekst)
        self.assertIn("nie wskazuje osoby", tekst)
        self.assertIn("pewność", tekst)

    def test_dane_lean_aktualne(self):
        plik = TU.parent.parent / "Konstytucja/TK/CiagloscDane.lean"
        self.assertEqual(plik.read_text(encoding="utf8"), lean.dane(REJ),
                         "uruchom: python3 tk_test.py lean")


class Warianty(unittest.TestCase):
    def test_liczby(self):
        self.assertEqual(parametry.liczba_nominalna("M1"), 216)
        self.assertEqual(parametry.liczba("M1"), 192)
        self.assertEqual(parametry.liczba("M2"), 27648)
        self.assertEqual(parametry.liczba("M2") * 2 ** len(przebieg.ROZSZERZENIA_M3), 1769472)

    def test_złączenie_jedna_wartość(self):
        i1 = next(parametry.warianty("M1"))
        for i2 in parametry.warianty("M2", i1):
            self.assertEqual(i2.klucz("M1"), i1.klucz("M1"))

    def test_F1_tylko_utożsamienia(self):
        for i in parametry.warianty("M1"):
            self.assertFalse(i.z7 == "c" and i.z4 == "bR2")
        # wariant z naruszeniami nie jest odrzucany (filtr nie zna danych)
        self.assertIn(Interpretacja(z1="b", z2="a", z4="a", z7="a", z12="a"),
                      list(parametry.warianty("M1")))


class H1(unittest.TestCase):
    """Zastosowanie Z7 do danych z 8.10.2015 (plan, H1)."""

    def wyprz(self, z7):
        alt = model.alternatywy(REJ)[0]
        st = model.oblicz(REJ, Interpretacja(z1="a", z2="a", z4="a", z7=z7, z12="a"), alt)
        return {o: st.wybory[o].powody["wyprzedzający"] for o in ("hauser", "sitek", "sokala")}

    def test_z7a(self):
        self.assertEqual(set(self.wyprz("a").values()), {W3.TAK})

    def test_z7b(self):
        w = self.wyprz("b")
        self.assertIs(w["hauser"], W3.NIE)
        self.assertIs(w["sitek"], W3.TAK)
        self.assertIs(w["sokala"], W3.TAK)

    def test_z7c(self):
        self.assertEqual(set(self.wyprz("c").values()), {W3.NIE})

    def test_pierwsze_dni_wakatów(self):
        st = model.oblicz(REJ, Interpretacja(z1="a", z2="a", z4="a", z7="c", z12="a"),
                          model.alternatywy(REJ)[0])
        self.assertEqual(st.wybory["hauser"].f.lo, data("2015-11-06"))
        self.assertEqual(st.wybory["sitek"].f.lo, data("2015-12-02"))


class T10(unittest.TestCase):
    """Przykład kontrolny z recenzji, sekcja 15 (dni 10/15/20 w skali dat)."""

    def setUp(self):
        self.r = rej_z(
            "A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\n"
            "B,E2,2010-01-10,x,,forma=wobec_prezydenta,DOC:x,ustalone,\n"
            "C,E5,2019-01-15,x,,rodzaj=orzeczenie,DOC:x,ustalone,\n"
            "D,UCHWALA_STATUS,2018-01-01,,,dotyczy=x,DOC:x,ustalone,\n")
        self.assertEqual(self.r.błędy, [])
        st = model.oblicz(self.r, Interpretacja(z1="a", z2="a", z4="a", z7="c", z12="a"),
                          model.alternatywy(self.r)[0])
        self.w = st.wybory["x"]

    def test_tytuł(self):
        self.assertIs(self.w.ma_tytuł(data("2019-01-09")), W3.TAK)
        self.assertIs(self.w.ma_tytuł(data("2019-01-10")), W3.NIE)

    def test_funkcja_po_utracie_tytułu(self):
        f = self.w.w_funkcji
        self.assertIs(f(data("2019-01-12")), W3.NIEUST)
        self.assertIs(f(data("2019-01-15")), W3.TAK)
        self.assertIs(f(data("2019-01-16")), W3.NIEUST)  # ostatnie E5 nie zamyka niepewności
        self.assertIs(f(data("2026-11-16")), W3.NIEUST)

    def test_E10_kończy_funkcję(self):
        r = rej_z("A,E1,2009-12-01,x,,poczatek=2010-01-10;glosowanie=odrebne,ELI:MP/1,ustalone,\n"
                  "B,E10,2019-02-01,x,,,DOC:x,ustalone,\n"
                  "D,UCHWALA_STATUS,2018-01-01,,,dotyczy=x,DOC:x,ustalone,\n")
        st = model.oblicz(r, Interpretacja(z1="a", z2="a", z4="a", z7="c", z12="a"),
                          model.alternatywy(r)[0])
        self.assertIs(st.wybory["x"].w_funkcji(data("2019-02-01")), W3.NIE)
        self.assertIs(st.wybory["x"].w_funkcji(data("2019-01-20")), W3.NIEUST)


class KworumP10(unittest.TestCase):
    """Kontrprzykład z recenzji (13.2): 7 pewnych (4 obecne), 2 niepewne (1 obecna)."""

    def test_przegląd_uzupełnień(self):
        wiersze = []
        for n in range(9):
            pocz = "2010-01-10"
            wiersze.append(f"E{n},E1,2009-12-01,p{n},,poczatek={pocz};glosowanie=odrebne,ELI:MP/{n},ustalone,")
        r = rej_z("\n".join(wiersze) + "\n")
        st = model.oblicz(r, Interpretacja(z1="a", z2="a", z4="a", z7="c", z12="a"),
                          model.alternatywy(r)[0])
        t = data("2012-01-01")
        for o in ("p7", "p8"):  # tytuły nieustalone, różne miejsca
            w = st.wybory[o]
            w.tytuł = [(p, W3.NIEUST) for p, _ in w.tytuł]
        obecni = ["p0", "p1", "p2", "p3", "p7"]
        wyniki = set()
        for u in oceny.uzupełnienia(st, [f"p{n}" for n in range(9)], t):
            z_tyt = sum(u.values())
            obecni_t = sum(1 for o in obecni if u[o])
            wyniki.add(obecni_t * 2 > z_tyt)
        self.assertEqual(wyniki, {True, False})
        self.assertEqual(oceny.agreguj(wyniki), oceny.NIEUSTALONY)


class Orzeczenia(unittest.TestCase):
    def kier_i_stan(self, **kw):
        i = Interpretacja(z1="a", z2="a", z4="a", z7="b", z12="a", z3c="a", z3q="b", z3m="b",
                          z5="a", z5z="b", z8="b", z6="a", z9="b", z10="a", z11="a", z13="b",
                          z14="a")
        i = parametry.replace(i, **kw) if kw else i
        st = model.oblicz(REJ, i, model.alternatywy(REJ)[0])
        return st, i, oceny.krok6(REJ, st, i)

    def test_z13b_bez_wyniku_głosowania_nieustalony(self):
        st, i, kier = self.kier_i_stan()
        wyn = {r.a("sprawa"): det for r, det, _ in oceny.krok7(REJ, st, i, kier)}
        self.assertEqual(wyn["K 2/25"]["skutek_a"], oceny.NIEUSTALONY)

    def test_większość_z_wyniku_nie_ze_zdań_odrębnych(self):
        st, i, kier = self.kier_i_stan()
        wyn = {r.a("sprawa"): det for r, det, _ in oceny.krok7(REJ, st, i, kier)}
        self.assertEqual(wyn["K 1/17"]["wykrycie_c"], oceny.NIEUSTALONY)  # są zdania odrębne
        self.assertEqual(wyn["U 5/24"]["wykrycie_c"], "NIE")  # jednogłośnie

    def test_konflikt_z10(self):
        st, i, kier = self.kier_i_stan()
        wyn = {r.a("sprawa"): det for r, det, _ in oceny.krok7(REJ, st, i, kier)}
        self.assertEqual(wyn["K 1/17"]["wykrycie_e"], "TAK")
        self.assertEqual(wyn["Kp 3/24"]["wykrycie_e"], "NIE")
        st, i, kier = self.kier_i_stan(z10="b")
        wyn = {r.a("sprawa"): det for r, det, _ in oceny.krok7(REJ, st, i, kier)}
        self.assertEqual(wyn["Kp 3/24"]["wykrycie_e"], "TAK")


class Publikacja(unittest.TestCase):
    def test_rpub(self):
        p = {x["sprawa"]: x for x in oceny.krok8(REJ, (14, 30, 60))}
        self.assertEqual(p["K 47/15"]["czas"], 818)
        self.assertEqual(p["K 47/15"]["w6b"], oceny.NIEUSTALONY)  # tylko zapowiedź O1
        self.assertTrue(p["K 47/15"]["przekroczenia"][60])  # opis, nie ocena
        self.assertEqual(p["Kp 3/24"]["w6b"], oceny.NIE_DOTYCZY)

    def test_odmowa_wykonana(self):
        r = rej_z("X,E1,2009-12-01,x,,poczatek=2010-01-10,ELI:MP/1,ustalone,\n"
                  "R,ORZ,2016-01-10,,,sprawa=K 1/16;art188=tak;sklad=x;wynik=jednoglosnie,IPO:K 1/16,ustalone,\n"
                  "P,PUB,2016-01-20,,,sprawa=K 1/16;zdarzenie=O2;organ=prm,DOC:x,ustalone,\n"
                  "Q,PUB,2016-05-01,,,sprawa=K 1/16;zdarzenie=O3;organ=prm,ELI:DU/1,ustalone,\n")
        p = oceny.krok8(r, (14,))[0]
        self.assertEqual(p["w6b"], oceny.NARUSZONY)
        self.assertEqual(p["przedział_naruszenia"], (data("2016-01-20"), data("2016-05-01")))


class Przebieg(unittest.TestCase):
    def test_przebieg_częściowy(self):
        W = przebieg.przebieg(REJ, limit_m1=2)
        a = len(model.alternatywy(REJ))
        self.assertEqual(W.liczba_wariantów["M1"], 2 * a)
        self.assertEqual(W.liczba_wariantów["M2"], 2 * a * 144)
        self.assertEqual(W.liczba_wariantów["M3"], 2 * a * 144 * 64)
        self.assertTrue(W.agregaty["orzeczenie:K 1/17"].liczby)

    def test_założenia_danych_wyłączone_dają_nieustalenie(self):
        ad = ZałożeniaDanych(ad1_brak_innych_E6=False)
        st = model.oblicz(REJ, Interpretacja(z1="a", z2="a", z4="a", z7="b", z12="a"),
                          model.alternatywy(REJ)[0], ad)
        self.assertIs(st.wybory["kieres"].ma_tytuł(data("2016-01-01")), W3.NIEUST)


if __name__ == "__main__":
    unittest.main()
