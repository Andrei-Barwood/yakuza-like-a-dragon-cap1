# Mecánicas y Reglas de Dominio — Episodio 12: Duelo con Sawashiro (`12_el_guantelete`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El asalto requiere que la infiltración al edificio se haya completado en el sótano (`building_infiltrated => true`).
  - La apertura de las puertas del despacho exige que Sawashiro haya sido derrotado (`sawashiro_boss_defeated => true`).
- **Efectos de Estado:**
  - `sawashiro`: HP se reduce a 0, atributo `:status => :defeated`.
  - Flags de estado:
    - `:executive_floor_breached => true`
    - `:sawashiro_confronted => true`
    - `:sawashiro_boss_defeated => true`
    - `:adachi_holding_corridor => true`
    - `:path_to_arakawa_opened => true`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.scene_transition` (a `stairs_breach_to_executive_floor`)
- `story.scene_transition` (a `sawashiro_confrontation`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:sawashiro`, data: `{ victory: true, type: :boss_duel }`)
- `story.scene_transition` (a `corridor_breach_to_patriarch`)
- `story.objective_completed` (actor: `:ichiban`, data: `{ action: "reach_arakawa_office" }`)
- `story.scenario_completed` (actor: `:ichiban`)
