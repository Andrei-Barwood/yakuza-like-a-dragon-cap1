# Mecánicas y Reglas de Dominio — Episodio 11: Los conductos subterráneos (`11_los_bajos_fondos`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El ingreso a las alcantarillas requiere que Adachi esté en el grupo (`has_character?(:adachi)`).
  - La apertura de la escotilla requiere que el puesto de guardia subterráneo haya sido despejado (`sewer_guards_defeated => true`).
  - La llegada al sótano requiere que la escotilla esté abierta (`access_hatch_opened => true`).
- **Efectos de Estado:**
  - Cambio de ubicación: De Alcantarillado a Sótano del Edificio de la Cumbre.
  - Flags de estado:
    - `:sewer_navigated => true`
    - `:sewer_guards_defeated => true`
    - `:access_hatch_opened => true`
    - `:building_infiltrated => true`
    - `:next_step => :storm_executive_floor`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.scene_transition` (a `sewer_descent`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:omi_tunnel_guards`, data: `{ assisted_by: :adachi, victory: true }`)
- `story.objective_completed` (actor: `:ichiban`, data: `{ action: "force_maintenance_hatch" }`)
- `story.scene_transition` (a `building_basement_arrival`)
- `story.scenario_completed` (actor: `:ichiban`)
