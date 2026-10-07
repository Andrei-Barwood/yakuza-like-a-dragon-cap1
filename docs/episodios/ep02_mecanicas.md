# Mecánicas y Reglas de Dominio — Episodio 02: El trabajo del día (`02_cobranza`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - `ushio_den_confrontation` exige que `target_identified` sea verdadero.
  - `ushio_combat` exige que Ushio esté presente y haya rechazado el pago pacífico.
  - `moral_choice_reimbursement` exige que el combate haya sido resuelto favorablemente (`combat_resolved`).
- **Mecánica de Cobranza y Decisión:**
  - Monto total recuperado del local: ¥250,000.
  - Decisión canon del laboratorio: Reembolsar ¥50,000 a las víctimas timadas (`:buyers_reimbursed => true`), conservando los ¥200,000 debidos a la familia.
  - Dinero en mano de Ichiban: pasa de ¥2,000 iniciales a ¥202,000 recaudados.
- **Relaciones:**
  - `ichiban` -> `mitsuo`: se refuerza a `:loyal_comrade`.
  - `ushio`: pasa a `status => :defeated`.

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.objective_started` (actor: `:ichiban`, data: `{ task: "locate_and_collect_debt", target: :ushio }`)
- `story.scene_transition` (a `ushio_den_confrontation`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:ushio`, data: `{ victory: true }`)
- `story.scene_transition` (a `moral_choice_reimbursement`)
- `story.choice_recorded` (actor: `:ichiban`, data: `{ choice: :refund_buyers, amount_refunded: 50000 }`)
- `story.debt_collected` (actor: `:ichiban`, target: `:ushio`, data: `{ amount_collected: 200000 }`)
- `story.scenario_completed` (actor: `:ichiban`)
