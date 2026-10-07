# Secuencia de Escenas — Episodio 02: El trabajo del día (`02_cobranza`)

## Escena 1: `streets_morning_patrol` (Ronda matutina)
- **Ubicación:** Kamurocho - Tenkaichi Street.
- **Participantes:** `ichiban`, `mitsuo`.
- **Objetivo:** Discutir las órdenes de la familia Arakawa y ubicar al objetivo de cobranza.
- **Acciones:**
  - `brief_target`: Mitsuo explica que Hirotaka Ushio debe dinero a la familia y está escondido en un local de contrabando.
- **Transición:** Conduce a `ushio_den_confrontation`.

## Escena 2: `ushio_den_confrontation` (Confrontación en el local de Ushio)
- **Ubicación:** Callejón Nakamichi - Local clandestino.
- **Participantes:** `ichiban`, `mitsuo`, `ushio` (usurero).
- **Precondiciones:** El objetivo debe haber sido identificado (`target_identified`).
- **Objetivo:** Exigir el pago correspondiente a la familia Arakawa.
- **Acciones:**
  - `demand_payment`: Ichiban exige los ¥200,000 adeudados.
  - `ushio_resists`: Ushio se niega e intenta expulsar violentamente a Ichiban y Mitsuo.
- **Transición:** Conduce a `ushio_combat`.

## Escena 3: `ushio_combat` (Combate callejero contra Ushio)
- **Ubicación:** Local clandestino / callejón exterior.
- **Participantes:** `ichiban`, `ushio`.
- **Precondiciones:** Confrontación iniciada con negativa de pago.
- **Objetivo:** Neutralizar la resistencia de Ushio.
- **Acciones:**
  - `resolve_brawl`: Ichiban supera físicamente a Ushio y reduce su HP a 0.
- **Transición:** Conduce a `moral_choice_reimbursement`.

## Escena 4: `moral_choice_reimbursement` (Decisión moral: El reembolso a los clientes)
- **Ubicación:** Callejón Nakamichi.
- **Participantes:** `ichiban`, `mitsuo`, `ushio` (sometido).
- **Precondiciones:** Ushio derrotado en combate.
- **Objetivo:** Manejar el botín recaudado al descubrir cómo estafaba a compradores incautos.
- **Acciones:**
  - `refund_victims`: Ichiban aparta ¥50,000 para devolvérselo a los clientes estafados y entrega a la familia los ¥200,000 netos cobrados legítimamente.
  - `mitsuo_reaction`: Mitsuo cuestiona la lógica pero asume el carácter recto de Ichiban.
- **Transición:** Concluye el episodio con la recaudación lista.
