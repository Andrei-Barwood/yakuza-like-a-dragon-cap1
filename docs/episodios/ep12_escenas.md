# Secuencia de Escenas — Episodio 12: Duelo con Sawashiro (`12_el_guantelete`)

## Escena 1: `stairs_breach_to_executive_floor` (Asalto a la planta ejecutiva)
- **Ubicación:** Escaleras de emergencia hacia la planta ejecutiva.
- **Participantes:** `ichiban`, `adachi`.
- **Objetivo:** Subir desde el sótano y derribar la puerta de servicio.
- **Acciones:**
  - `burst_through_door`: Irrumpen en el pasillo alfombrado del piso de mando.
- **Transición:** Conduce a `sawashiro_confrontation`.

## Escena 2: `sawashiro_confrontation` (El reencuentro con Sawashiro)
- **Ubicación:** Pasillo principal de la planta ejecutiva.
- **Participantes:** `ichiban`, `adachi`, `sawashiro`.
- **Precondiciones:** Entrada en la planta ejecutiva.
- **Objetivo:** Enfrentar verbalmente al capitán por el que Ichiban se sacrificó 18 años.
- **Acciones:**
  - `exchange_words`: Sawashiro desenfunda su arma burlándose de los "principios idiotas" de Ichiban.
- **Transición:** Conduce a `sawashiro_boss_duel`.

## Escena 3: `sawashiro_boss_duel` (Duelo de jefe contra Sawashiro)
- **Ubicación:** Salón ceremonial de la planta ejecutiva.
- **Participantes:** `ichiban`, `adachi`, `sawashiro`.
- **Precondiciones:** Confrontación iniciada.
- **Objetivo:** Vencer la destreza marcial de Jo Sawashiro.
- **Acciones:**
  - `defeat_sawashiro`: Tras un feroz intercambio de golpes y bloqueos, Ichiban noquea a Sawashiro.
- **Transición:** Conduce a `corridor_breach_to_patriarch`.

## Escena 4: `corridor_breach_to_patriarch` (Camino abierto al despacho)
- **Ubicación:** Puerta doble de la oficina presidencial de la Omi.
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Sawashiro derrotado.
- **Objetivo:** Separar caminos para que Ichiban confronte a Masumi Arakawa a solas.
- **Acciones:**
  - `adachi_stands_guard`: Adachi bloquea la entrada del pasillo frente a la guardia de la Omi y le grita a Ichiban que entre.
  - `open_double_doors`: Ichiban empuja las puertas hacia el despacho final.
