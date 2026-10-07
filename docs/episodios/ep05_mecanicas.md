# Mecánicas y Reglas de Dominio — Episodio 05: Una noche para Masato (`05_el_joven_maestro`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El episodio requiere que la orden de Sawashiro esté activa (`sawashiro_summons => true`).
  - La escena `hostess_club_lounge` requiere la presencia de Masato.
  - La escena `overhearing_backstage` requiere que Masato haya solicitado a Yumeno.
  - La escena `masato_departure_and_bill` requiere que la verdad sobre Yumeno haya sido escuchada (`heard_yumeno_truth => true`).
- **Mecánica Financiera y Pertenencias:**
  - Cartera de Masato recibida: contiene ¥100,000.
  - Costo de la cuenta del club: ¥80,000.
  - Saldo de la cartera de Masato tras pagar la cuenta: ¥20,000.
  - Ichiban retiene la pertenencia `:masato_wallet` para su devolución en la oficina de la familia.
  - Los fondos de Ichiban provenientes del cobro a Ushio y Hiratsuka (¥252,000) permanecen intactos.
- **Flags y Estados:**
  - `:heard_yumeno_truth => true`
  - `:masato_departed => true`
  - `:club_bill_paid => true`
  - `:masato_wallet_held => true`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.objective_started` (actor: `:ichiban`, data: `{ task: "escort_masato", destination: "Hostess Club" }`)
- `story.scene_transition` (a `hostess_club_lounge`)
- `story.scene_transition` (a `overhearing_backstage`)
- `story.information_revealed` (actor: `:ichiban`, target: `:yumeno`, data: `{ fact: "yumeno_exploits_masato" }`)
- `story.scene_transition` (a `masato_departure_and_bill`)
- `story.item_acquired` (actor: `:ichiban`, target: `:masato`, data: `{ item: :masato_wallet }`)
- `story.payment_made` (actor: `:ichiban`, data: `{ expense: :club_bill, amount: 80000, source: :masato_wallet }`)
- `story.character_departed` (actor: `:masato`, data: `{ reason: "humiliation_and_anger" }`)
- `story.scenario_completed` (actor: `:ichiban`)
