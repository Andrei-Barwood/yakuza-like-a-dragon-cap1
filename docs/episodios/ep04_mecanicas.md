# Mecánicas y Reglas de Dominio — Episodio 04: Cobrar sin destruir (`04_lo_que_se_debe`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El episodio requiere que el objetivo inicial de cobranza sea Hiratsuka (`:hiratsuka`).
  - `wallet_inspection_and_mercy` requiere que Hiratsuka esté derrotado (`status == :defeated`).
  - La transición a la llamada de Sawashiro requiere que la cobranza parcial haya sido resuelta (`flag?(:partial_collection)`).
- **Mecánica Financiera y Decisión:**
  - Dinero en la cartera de Hiratsuka: ¥100,000.
  - Decisión canon del laboratorio: Retener ¥50,000 y perdonar/dejar los restantes ¥50,000.
  - Dinero total en manos de Ichiban: se incrementa en +¥50,000 (de ¥202,000 a ¥252,000 acumulados).
- **Flags y Estados:**
  - `hiratsuka`: status pasa a `:defeated`, HP a 0.
  - `:hiratsuka_spared => true`
  - `:partial_collection => true`
  - `:sawashiro_summons => true`
  - `:next_assignment_target => :masato`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.objective_started` (actor: `:ichiban`, data: `{ target: :hiratsuka, location: "Public Park 3" }`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:hiratsuka`, data: `{ victory: true }`)
- `story.choice_recorded` (actor: `:ichiban`, data: `{ choice: :spare_half_debt, retained: 50000, spared: 50000 }`)
- `story.debt_collected` (actor: `:ichiban`, target: `:hiratsuka`, data: `{ amount: 50000 }`)
- `story.communication_received` (actor: `:sawashiro`, target: `:ichiban`, data: `{ order: "attend_masato" }`)
- `story.scenario_completed` (actor: `:ichiban`)
