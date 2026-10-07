# Secuencia de Escenas — Episodio 11: Los conductos subterráneos (`11_los_bajos_fondos`)

## Escena 1: `sewer_descent` (Descenso a las cloacas)
- **Ubicación:** Alcantarillado de Kamurocho - Nivel superior.
- **Participantes:** `ichiban`, `adachi`.
- **Objetivo:** Abrir la reja y adentrarse en la red de túneles bajo la ciudad.
- **Acciones:**
  - `navigate_darkness`: Avanzan en la penumbra sorteando tuberías y agua estancada.
- **Transición:** Conduce a `underground_security_checkpoint`.

## Escena 2: `underground_security_checkpoint` (El puesto de guardia subterráneo)
- **Ubicación:** Alcantarillado - Cruce de compuertas.
- **Participantes:** `ichiban`, `adachi`, `omi_tunnel_guards`.
- **Precondiciones:** Descenso completado.
- **Objetivo:** Neutralizar a los centinelas armados de la Omi apostados en el cruce.
- **Acciones:**
  - `clear_checkpoint`: Ichiban y Adachi asaltan la posición y reducen a los guardias.
- **Transición:** Conduce a `maintenance_hatch_breach`.

## Escena 3: `maintenance_hatch_breach` (Forzar la escotilla de mantenimiento)
- **Ubicación:** Final del túnel / Base del edificio.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Guardias del túnel derrotados.
- **Objetivo:** Desbloquear la escotilla blindada que conecta con las instalaciones del edificio.
- **Acciones:**
  - `force_hatch`: Adachi apalanca el cerrojo y logran abrir la compuerta de acceso.
- **Transición:** Conduce a `building_basement_arrival`.

## Escena 4: `building_basement_arrival` (Llegada al sótano del edificio)
- **Ubicación:** Sótano del Edificio de la Cumbre.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Escotilla forzada con éxito.
- **Objetivo:** Posicionarse al pie de las escaleras de emergencia hacia la cumbre.
- **Acciones:**
  - `prep_for_breach`: Ajustan sus fuerzas antes de subir hacia la reunión donde se encuentra Arakawa.
