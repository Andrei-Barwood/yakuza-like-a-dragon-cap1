# Mecánicas y Reglas de Dominio — Episodio 07: Quince años (`07_el_precio`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El episodio requiere que Ichiban haya descansado en la noche previa (`resting_for_night => true`).
  - La reunión a solas con Arakawa requiere que la emboscada de los Sakaki haya sido repelida (`sakaki_ambush_repelled => true`).
  - La entrega a la policía exige que Ichiban haya aceptado la asunción del crimen (`accepted_prison_sacrifice => true`).
- **Efectos de Estado y Pertenencias:**
  - `ichiban`: Pasa a condición de recluso (`role => :prisoner`, `status => :incarcerated`).
  - Dinero restante: ¥0 (entregado o confiscado al ingresar en prisión).
  - Pertenencias: desposeído de insignias (`arakawa_pin` retirado).
  - Ubicación final: `"Centro de Detención de Kamurocho"`.
  - Flags de estado:
    - `:sakaki_ambush_repelled => true`
    - `:crime_revealed => :sawashiro_homicide`
    - `:accepted_prison_sacrifice => true`
    - `:last_meal_consumed => true`
    - `:surrendered_to_police => true`
    - `:imprisoned => true`
    - `:chapter_1_completed => true`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.emergency_call` (actor: `:arakawa`, target: `:ichiban`, data: `{ reason: "urgent_crisis" }`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:sakaki_thugs`, data: `{ victory: true }`)
- `story.scene_transition` (a `patriarch_solemn_request`)
- `story.crime_confessed_privately` (actor: `:arakawa`, data: `{ true_culprit: :sawashiro }`)
- `story.choice_recorded` (actor: `:ichiban`, data: `{ choice: :accept_blame_for_family, sacrifice: :prison_term }`)
- `story.scene_transition` (a `the_last_meal_and_surrender`)
- `story.meal_shared` (actor: `:ichiban`, target: `:arakawa`, data: `{ meal: :beef_bowl }`)
- `story.legal_surrender` (actor: `:ichiban`, target: `:police`, data: `{ charge: :murder_confession }`)
- `story.chapter_boundary` (actor: `:ichiban`, data: `{ chapter: 1, status: :concluded, next: :out_of_scope }`)
- `story.scenario_completed` (actor: `:ichiban`)
