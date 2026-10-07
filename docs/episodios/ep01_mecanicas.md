# Mecánicas y Reglas de Dominio — Episodio 01: La primera deuda (`01_origen`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - No se puede ingresar a `dinner_at_eatery` sin completar `theatre_dressing_room`.
  - No se puede pasar a la emboscada sin haber completado la cena.
  - La muerte de Toshio es un suceso inevitable de canon narrativo; no se puede alterar el destino de Toshio.
- **Efectos de Estado:**
  - `masumi`: Adquiere el flag `:father_killed` y el atributo `:trauma => :father_killed`.
  - `toshio`: HP se reduce a 0, atributo `:status => :deceased`.
  - Flags de mundo:
    - `:performance_finished => true`
    - `:dinner_shared => true`
    - `:ambush_occurred => true`
    - `:vow_recorded => true`

## Catálogo de Eventos Estables
- `story.objective_started` (actor: `:masumi`, escena: `theatre_dressing_room`)
- `story.scene_transition` (a `dinner_at_eatery`)
- `story.meal_shared` (actor: `:toshio`, target: `:masumi`)
- `story.scene_transition` (a `dark_alleyway_ambush`)
- `story.ambush_triggered` (actor: `:assassin`, target: `:toshio`)
- `story.sacrifice_recorded` (actor: `:toshio`, target: `:masumi`)
- `story.scene_transition` (a `prologue_aftermath`)
- `story.chapter_boundary` (conclusión del prólogo de 1977)
