"""Parametry Z1-Z14 i N1, graf zależności modułów oraz generator wariantów (pkt 5 i 5.1).

Wspólny parametr ma w jednym wariancie jedną wartość; moduł wyższego rzędu powstaje przez
złączenie po wspólnych identyfikatorach (dep(M2) = dep(M1) ∪ {...}), a nie przez
ponowne losowanie tych samych pól. Filtr F1 odrzuca wyłącznie warianty utożsamione
(4.6) - nigdy z powodu wykrytych naruszeń.
"""
from __future__ import annotations

import itertools
from dataclasses import dataclass, fields, replace

# Identyfikator -> (wartości, opis, luka). Status wszystkich parametrów: roboczy (Z9 plan.txt).
PARAMETRY: dict[str, tuple[tuple[str, ...], str, str]] = {
    "z1": (("a", "b", "c", "d14", "d30", "d90"), "objęcie urzędu (dX = fikcja po X dniach)", "L1"),
    "z2": (("a", "b"), "początek kadencji: a dzień wakatu, b dzień objęcia", "L2"),
    "z3c": (("a", "b"), "ZO zwołanie", "L4"),
    "z3q": (("a", "b"), "ZO kworum", "L4"),
    "z3m": (("a", "b", "c"), "ZO większość", "L4"),
    "z4": (("a", "bR1", "bR2"), "wybór na wakat zajęty i zakres konwalidacji (4.6)", "L6"),
    "z5": (("a", "b"), "kadencja Prezesa", "L8"),
    "z5z": (("a", "b", "c"), "zastępstwo Prezesa", "L8"),
    "z6": (("a", "b"), "art. 45 wobec TK", "W11"),
    "z7": (("a", "b", "c"), "wybór na przyszły wakat", "L7"),
    "z8": (("a", "b"), "udział osoby bez tytułu w ZO", "L9"),
    "z9": (("a", "b"), "wadliwe wyznaczenie składu", "L10"),
    "z10": (("a", "b"), "zakres konfliktu interesów", "L12"),
    "z11": (("a", "b"), "kworum składów (b = NIEPOKRYTY)", "L3"),
    "z12": (("a", "b"), "tryb wyboru przez Sejm", "L13"),
    "z13": (("a", "b"), "skutek udziału osoby bez tytułu w składzie", "L14"),
    "z14": (("a", "b"), "skutek konfliktu interesów", "L12"),
}
N1 = (14, 30, 60)  # wskaźnik (P9) - tylko tabela E
K4_X = (0.10, 0.25, 0.50)  # wskaźnik (P9) - tylko K4

DEP: dict[str, tuple[str, ...]] = {
    "M1": ("z1", "z2", "z4", "z7", "z12"),
}
DEP["M2"] = DEP["M1"] + ("z3c", "z3q", "z3m", "z5", "z5z", "z8")
DEP["M3"] = DEP["M2"] + ("z6", "z9", "z10", "z11", "z13", "z14")
DEP["M4"] = ()


@dataclass(frozen=True)
class Interpretacja:
    z1: str | None = None
    z2: str | None = None
    z3c: str | None = None
    z3q: str | None = None
    z3m: str | None = None
    z4: str | None = None
    z5: str | None = None
    z5z: str | None = None
    z6: str | None = None
    z7: str | None = None
    z8: str | None = None
    z9: str | None = None
    z10: str | None = None
    z11: str | None = None
    z12: str | None = None
    z13: str | None = None
    z14: str | None = None

    @property
    def fikcja_T(self) -> int | None:
        return int(self.z1[1:]) if self.z1 and self.z1.startswith("d") else None

    def klucz(self, moduł: str) -> tuple[str, ...]:
        return tuple(getattr(self, p) for p in DEP[moduł])

    def opis(self) -> str:
        return " ".join(f"{f.name.upper()}={getattr(self, f.name)}" for f in fields(self)
                        if getattr(self, f.name) is not None)


def utożsamiony(i: Interpretacja) -> bool:
    """4.6: przy Z7c powód "wybór wyprzedzający" nie występuje, więc Z4.R2 ≡ Z4.R1.

    Kanonicznym przedstawicielem jest R1; wariant z R2 jest utożsamiony (pomijany).
    """
    return i.z7 == "c" and i.z4 == "bR2"


def warianty(moduł: str, baza: Interpretacja | None = None):
    """Wszystkie warianty modułu po filtrze F1; przy `baza` - tylko dopełnienie jej pól."""
    params = [p for p in DEP[moduł] if baza is None or getattr(baza, p) is None]
    for wartości in itertools.product(*(PARAMETRY[p][0] for p in params)):
        i = replace(baza or Interpretacja(), **dict(zip(params, wartości)))
        if not utożsamiony(i):
            yield i


def liczba_nominalna(moduł: str) -> int:
    n = 1
    for p in DEP[moduł]:
        n *= len(PARAMETRY[p][0])
    return n


def liczba(moduł: str) -> int:
    return sum(1 for _ in warianty(moduł))


def zmiany(i: Interpretacja, p: str):
    """Warianty różniące się od `i` tylko parametrem p (do tabeli F, analiza wpływu)."""
    for v in PARAMETRY[p][0]:
        if v != getattr(i, p):
            j = replace(i, **{p: v})
            if not utożsamiony(j):
                yield j
