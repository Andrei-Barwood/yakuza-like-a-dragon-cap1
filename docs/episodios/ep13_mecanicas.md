# Mecánicas y Reglas de Dominio — Episodio 13: Reunión sangrienta (`13_reunion_sangrienta`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El acceso al despacho requiere que el camino haya sido abierto en el episodio previo (`path_to_arakawa_opened => true`).
  - El despertar en Yokohama requiere que el disparo de Arakawa se haya registrado (`shot_by_arakawa => true`).
  - La intervención de Nanba requiere que Ichiban esté en estado crítico de salud (`status == :critically_wounded`).
- **Efectos de Estado y Pertenencias:**
  - `ichiban`: HP reducido a 1, condición `:critically_wounded`, luego estabilizado por Nanba.
  - Relación de Ichiban con Arakawa: rota/cuestionada (`:betrayed_by_father`).
  - Relación con Nanba: establecida como `:savior`.
  - Ubicación final: `"Isezaki Ijincho - Campamento de Vagabundos (Yokohama)"`.
  - Flags de estado:
    - `:faced_arakawa => true`
    - `:shot_by_arakawa => true`
    - `:dumped_in_yokohama => true`
    - `:saved_by_nanba => true`
    - `:chapter_2_completed => true`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.scene_transition` (a `the_patriarch_audience`)
- `story.arakawa_betrayal_shot` (actor: `:arakawa`, target: `:ichiban`, data: `{ caliber: "lethal", location: "chest" }`)
- `story.scene_transition` (a `trash_heap_awakening`)
- `story.medical_treatment` (actor: `:nanba`, target: `:ichiban`, data: `{ procedure: "extracted_bullet", saved: true }`)
- `story.chapter_boundary` (actor: `:ichiban`, data: `{ chapter: 2, status: :concluded, next: :chapter_3 }`)
- `story.scenario_completed` (actor: `:ichiban`)
