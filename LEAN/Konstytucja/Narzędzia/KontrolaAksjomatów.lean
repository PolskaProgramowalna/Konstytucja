import Lean

/-! # Kontrola aksjomatów (zasada Z6)

`#kontrola_aksjomatów` sprawdza każdą deklarację z modułów `Konstytucja.*` i przerywa
kompilację, gdy zależy ona od czegoś spoza trzech standardowych aksjomatów Lean.
Dotyczy to też `sorryAx` i własnych `axiom`.
-/

open Lean Elab Command

elab "#kontrola_aksjomatów" : command => do
  let env ← getEnv
  let dozwolone := [``propext, ``Classical.choice, ``Quot.sound]
  let nazwy := env.constants.fold (init := (#[] : Array Name)) fun wynik nazwa _ =>
    match env.getModuleIdxFor? nazwa with
    | some i =>
      if (`Konstytucja).isPrefixOf env.header.moduleNames[i.toNat]! then wynik.push nazwa
      else wynik
    | none => wynik
  let mut błędy : Array String := #[]
  for nazwa in nazwy do
    let aksjomaty ← liftCoreM (collectAxioms nazwa)
    let złe := aksjomaty.filter (fun a => !dozwolone.contains a)
    unless złe.isEmpty do
      błędy := błędy.push s!"{nazwa}: {złe}"
  unless błędy.isEmpty do
    throwError "Niedozwolone aksjomaty:\n{"\n".intercalate błędy.toList}"
  logInfo m!"Sprawdzono deklaracji: {nazwy.size}"
