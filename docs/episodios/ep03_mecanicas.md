# Mecánicas y Reglas de Dominio — Episodio 03: Un favor en el barrio (`03_encargo_urgente`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - `street_skirmish_elderly`: Ocurre durante la trayectoria hacia la tienda tras aceptar el encargo.
  - `cigarette_shop_errand`: Requiere que el combate de protección al anciano haya sido resuelto (`elderly_protected`).
  - `shangri_la_resolution`: Requiere que el inventario contenga `:heavy_duty_plunger`. Intentar resolver sin el objeto genera un `IchibanLab::PreconditionError`.
- **Efectos de Estado:**
  - Adquisición del ítem `:heavy_duty_plunger` en la tienda.
  - Consumo/empleo del ítem en Shangri-La.
  - Flags de mundo:
    - `:favor_accepted => true`
    - `:elderly_protected => true`
    - `:plunger_acquired => true`
    - `:shangri_la_unclogged => true`
    - `:mitsuo_called => true`
    - `:next_assignment_target => :hiratsuka`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.objective_started` (actor: `:ichiban`, data: `{ task: "resolve_shangri_la_plumbing" }`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:street_thugs`, data: `{ protected: :elderly_man }`)
- `story.item_acquired` (actor: `:ichiban`, data: `{ item: :heavy_duty_plunger }`)
- `story.scene_transition` (a `shangri_la_resolution`)
- `story.objective_completed` (actor: `:ichiban`, data: `{ resolved: :shangri_la_toilet }`)
- `story.communication_received` (actor: `:mitsuo`, target: `:ichiban`, data: `{ assignment: "collect_hiratsuka_park_3" }`)
- `story.scenario_completed` (actor: `:ichiban`)
