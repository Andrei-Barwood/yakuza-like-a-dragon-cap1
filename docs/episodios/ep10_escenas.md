# Secuencia de Escenas — Episodio 10: Alianza con Adachi y Nick Ogata (`10_rescate_en_la_calle`)

## Escena 1: `pink_street_alley_cry` (Gritos en el callejón)
- **Ubicación:** Kamurocho - Callejón de Pink Street.
- **Participantes:** `ichiban`, `nick_ogata`, `street_extortionists`.
- **Objetivo:** Responder a los gritos de auxilio y evaluar la situación.
- **Acciones:**
  - `witness_extortion`: Ichiban ve a matones locales exigiendo dinero y pasaporte a Nick Ogata.
- **Transición:** Conduce a `brawl_protecting_nick`.

## Escena 2: `brawl_protecting_nick` (Combate en equipo por Nick Ogata)
- **Ubicación:** Callejón de Pink Street.
- **Participantes:** `ichiban`, `adachi`, `street_extortionists`.
- **Precondiciones:** Confrontación iniciada.
- **Objetivo:** Reducir a los agresores protegiendo a la víctima.
- **Acciones:**
  - `tag_team_combat`: Adachi se suma al combate; juntos aplastan a los extorsionadores.
- **Transición:** Conduce a `ogata_gratitude`.

## Escena 3: `ogata_gratitude` (La tarjeta de Nick Ogata)
- **Ubicación:** Callejón de Pink Street.
- **Participantes:** `ichiban`, `adachi`, `nick_ogata`.
- **Precondiciones:** Extorsionadores derrotados.
- **Objetivo:** Atender a Nick Ogata y recibir su agradecimiento.
- **Acciones:**
  - `receive_card`: Nick Ogata agradece la valentía de Ichiban y le entrega su tarjeta personal con una línea telefónica directa (`:nick_ogata_business_card`).
- **Transición:** Conduce a `adachi_party_pact`.

## Escena 4: `adachi_party_pact` (El pacto del grupo)
- **Ubicación:** Frente a la reja de alcantarillado (Hotel District).
- **Participantes:** `ichiban`, `adachi`.
- **Precondiciones:** Rescate de Nick Ogata finalizado.
- **Objetivo:** Formalizar la unión de Adachi al grupo y trazar el plan de infiltración.
- **Acciones:**
  - `join_party`: Adachi se incorpora oficialmente como compañero de equipo.
  - `reveal_sewer_access`: Adachi muestra la entrada a las alcantarillas de Kamurocho que conectan directamente bajo la sede de la cumbre.
