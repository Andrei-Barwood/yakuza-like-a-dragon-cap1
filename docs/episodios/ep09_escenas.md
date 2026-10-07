# Secuencia de Escenas — Episodio 09: El nuevo Kamurocho (`09_el_nuevo_kamurocho`)

## Escena 1: `tenkaichi_gate_arrival` (Llegada a Tenkaichi Street)
- **Ubicación:** Kamurocho - Tenkaichi Gate (2019).
- **Participantes:** `ichiban`, `adachi`.
- **Objetivo:** Contemplar la transformación del barrio y orientarse.
- **Acciones:**
  - `observe_streets`: Ichiban nota la ausencia de insignias del Clan Tojo y la frialdad de las calles patrulladas.
- **Transición:** Conduce a `old_headquarters_surveillance`.

## Escena 2: `old_headquarters_surveillance` (La antigua oficina ocupada)
- **Ubicación:** Callejón Nakamichi - Antigua sede de la Familia Arakawa.
- **Participantes:** `ichiban`, `omi_guards` (guardias de la Omi).
- **Precondiciones:** Llegada a Kamurocho consumada.
- **Objetivo:** Inspeccionar la sede donde Ichiban sirvió en el año 2000.
- **Acciones:**
  - `inspect_office`: Ichiban descubre que la placa de la Familia Arakawa ha sido sustituida por insignias de la Omi Alliance y guardias armados vigilan el portón.
- **Transición:** Conduce a `clash_with_omi_patrol`.

## Escena 3: `clash_with_omi_patrol` (Choque con la patrulla de la Omi)
- **Ubicación:** Callejón trasero frente a la sede.
- **Participantes:** `ichiban`, `omi_patrol`.
- **Precondiciones:** Presencia ante la antigua oficina.
- **Objetivo:** Enfrentar a los matones de Kansai que exigen a Ichiban marcharse a golpes.
- **Acciones:**
  - `defeat_omi_patrol`: Ichiban derrota a la patrulla en una refriega callejera.
- **Transición:** Conduce a `summit_lead_discovery`.

## Escena 4: `summit_lead_discovery` (La pista de la cumbre)
- **Ubicación:** Nakamichi Street.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Patrulla de la Omi derrotada.
- **Objetivo:** Extraer información al jefe de la patrulla sometido.
- **Acciones:**
  - `extract_intel`: El guardia confiesa que Masumi Arakawa presidirá esa misma noche una reunión de alto nivel de la Omi en un edificio fortificado del distrito.
  - `plan_infiltration`: Ichiban decide que entrará a esa reunión cueste lo que cueste.
