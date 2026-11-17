"""Daty, przedziały dat i logika trójwartościowa (plan_tk.txt, pkt 1 P4 i pkt 4.5)."""
from __future__ import annotations

import datetime as dt
from dataclasses import dataclass
from enum import Enum

Data = dt.date


class W3(Enum):
    """Wynik trójwartościowy (zasada P4)."""

    TAK = "TAK"
    NIE = "NIE"
    NIEUST = "NIEUSTALONY"

    def __and__(self, o: "W3") -> "W3":
        if self is W3.NIE or o is W3.NIE:
            return W3.NIE
        if self is W3.TAK and o is W3.TAK:
            return W3.TAK
        return W3.NIEUST

    def __or__(self, o: "W3") -> "W3":
        if self is W3.TAK or o is W3.TAK:
            return W3.TAK
        if self is W3.NIE and o is W3.NIE:
            return W3.NIE
        return W3.NIEUST

    def __invert__(self) -> "W3":
        return {W3.TAK: W3.NIE, W3.NIE: W3.TAK, W3.NIEUST: W3.NIEUST}[self]


def w3(b: bool) -> W3:
    return W3.TAK if b else W3.NIE


def data(s: str) -> Data:
    return dt.date.fromisoformat(s)


def plus_lata(d: Data, n: int) -> Data:
    """Dodanie lat kalendarzowych; 29 lutego przechodzi na 28 lutego (pkt 4.5)."""
    try:
        return d.replace(year=d.year + n)
    except ValueError:
        return d.replace(year=d.year + n, day=28)


def plus_dni(d: Data, n: int) -> Data:
    return d + dt.timedelta(days=n)


@dataclass(frozen=True)
class Chwila:
    """Data znana dokładnie (lo == hi) albo w granicach [lo, hi].

    `hi is None` oznacza brak górnej granicy w oknie badania.
    """

    lo: Data
    hi: Data | None

    @staticmethod
    def dokładnie(d: Data) -> "Chwila":
        return Chwila(d, d)

    @property
    def znana(self) -> bool:
        return self.hi == self.lo

    def plus_lata(self, n: int) -> "Chwila":
        return Chwila(plus_lata(self.lo, n), None if self.hi is None else plus_lata(self.hi, n))

    def plus_dni(self, n: int) -> "Chwila":
        return Chwila(plus_dni(self.lo, n), None if self.hi is None else plus_dni(self.hi, n))

    def __str__(self) -> str:
        if self.znana:
            return self.lo.isoformat()
        return f"[{self.lo.isoformat()}, {self.hi.isoformat() if self.hi else '?'}]"


def maks(a: Chwila, b: Chwila) -> Chwila:
    hi = None if a.hi is None or b.hi is None else max(a.hi, b.hi)
    return Chwila(max(a.lo, b.lo), hi)


def mini(a: Chwila, b: Chwila) -> Chwila:
    if a.hi is None and b.hi is None:
        hi = None
    elif a.hi is None:
        hi = b.hi
    elif b.hi is None:
        hi = a.hi
    else:
        hi = min(a.hi, b.hi)
    return Chwila(min(a.lo, b.lo), hi)


def przed(a: Chwila, b: Chwila) -> W3:
    """Czy a < b (ściśle)."""
    if a.hi is not None and a.hi < b.lo:
        return W3.TAK
    if b.hi is not None and b.hi <= a.lo:
        return W3.NIE
    return W3.NIEUST


def nie_później(a: Chwila, b: Chwila) -> W3:
    """Czy a <= b."""
    if a.hi is not None and a.hi <= b.lo:
        return W3.TAK
    if b.hi is not None and b.hi < a.lo:
        return W3.NIE
    return W3.NIEUST


@dataclass(frozen=True)
class Przedział:
    """Przedział półotwarty [od, do) o niepewnych końcach (pkt 4.5).

    `do is None` oznacza brak końca w oknie badania.
    """

    od: Chwila
    do: Chwila | None

    def zawiera(self, t: Data) -> W3:
        T = Chwila.dokładnie(t)
        po_początku = nie_później(self.od, T)
        przed_końcem = W3.TAK if self.do is None else przed(T, self.do)
        return po_początku & przed_końcem

    def zawiera_chwilę(self, c: Chwila) -> W3:
        """Czy niepewna chwila c (dowolna data z [c.lo, c.hi]) należy do przedziału.

        TAK - każda dopuszczalna data należy; NIE - żadna; NIEUSTALONY - niektóre.
        Sprawdzane są całe zakresy, a nie tylko końce (recenzja TKI-3).
        """
        # pewne zawieranie: najpóźniejszy możliwy początek <= c.lo i c.hi < najwcześniejszy koniec
        pewny_start = self.od.hi is not None and self.od.hi <= c.lo
        if self.do is None:
            pewny_koniec = True
        else:
            pewny_koniec = c.hi is not None and c.hi < self.do.lo
        if pewny_start and pewny_koniec:
            return W3.TAK
        # możliwe zawieranie: przecięcie [c.lo, c.hi] z [od.lo, do.hi) niepuste
        po_starcie = c.hi is None or self.od.lo <= c.hi
        przed_końcem = self.do is None or self.do.hi is None or c.lo < self.do.hi
        return W3.NIEUST if (po_starcie and przed_końcem) else W3.NIE

    def granice(self) -> list[Data]:
        """Daty, w których status przynależności może się zmienić."""
        out = [self.od.lo]
        if self.od.hi:
            out.append(self.od.hi)
        if self.do is not None:
            out.append(self.do.lo)
            if self.do.hi:
                out.append(self.do.hi)
        return out
