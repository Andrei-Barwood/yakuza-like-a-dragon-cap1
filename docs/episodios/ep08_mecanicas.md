# Mecánicas y Reglas de Dominio — Episodio 08: 18 años después (`08_liberacion`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El episodio requiere que el estado inicial refleje la salida carcelaria en 2019.
  - La conversación sobre la traición requiere que los agresores exteriores hayan sido derrotados (`ambush_survived => true`).
- **Efectos de Estado:**
  - `ichiban`: Atributo `:role => :former_convict`, condición `:freedom => true`.
  - Incorporación de `adachi`: id `:adachi`, rol `:former_detective`.
  - Flags de estado:
    - `:released_from_prison => true`
    - `:adachi_contacted => true`
    - `:ambush_survived => true`
    - `:heard_arakawa_betrayal => true`
    - `:destination => :kamurocho`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.prison_release` (actor: `:ichiban`, data: `{ year: 2019, years_served: 18 }`)
- `story.character_introduced` (actor: `:adachi`, target: `:ichiban`, data: `{ role: :ex_detective }`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:arakawa_thugs`, data: `{ assisted_by: :adachi, victory: true }`)
- `story.information_revealed` (actor: `:adachi`, target: `:ichiban`, data: `{ news: "arakawa_betrayal_and_omi_rise" }`)
- `story.objective_started` (actor: `:ichiban`, data: `{ goal: "return_to_kamurocho" }`)
- `story.scenario_completed` (actor: `:ichiban`)
