# Mecánicas y Reglas de Dominio — Episodio 09: El nuevo Kamurocho (`09_el_nuevo_kamurocho`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El episodio requiere que el destino previo sea Kamurocho (`destination == :kamurocho`).
  - La extracción de la pista requiere que la patrulla de la Omi haya sido derrotada en combate (`omi_patrol_defeated => true`).
- **Efectos de Estado:**
  - Ubicación: De Tenkaichi Gate a Callejón Nakamichi.
  - Dinero obtenido en combate: +¥3,000 (despojos de la patrulla).
  - Flags de estado:
    - `:kamurocho_entered => true`
    - `:old_office_inspected => true`
    - `:omi_patrol_defeated => true`
    - `:summit_meeting_discovered => true`
    - `:next_objective => :find_way_into_summit`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.scene_transition` (a `tenkaichi_gate_arrival`)
- `story.scene_transition` (a `old_headquarters_surveillance`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:omi_patrol`, data: `{ victory: true }`)
- `story.information_revealed` (actor: `:omi_patrol`, target: `:ichiban`, data: `{ intel: "arakawa_attending_omi_summit_tonight" }`)
- `story.objective_started` (actor: `:ichiban`, data: `{ goal: "infiltrate_omi_summit" }`)
- `story.scenario_completed` (actor: `:ichiban`)
