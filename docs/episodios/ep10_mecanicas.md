# Mecánicas y Reglas de Dominio — Episodio 10: Alianza con Adachi y Nick Ogata (`10_rescate_en_la_calle`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El combate exige que los extorsionadores estén presentes amenazando a Nick Ogata.
  - La entrega de la tarjeta de negocios exige que el combate haya concluido exitosamente (`extortionists_defeated => true`).
  - La revelación del acceso subterráneo requiere la unión formal de Adachi al grupo (`adachi_party_joined => true`).
- **Efectos de Estado e Inventario:**
  - Adquisición del ítem `:nick_ogata_business_card` en el inventario.
  - Relación mutua: `ichiban` y `adachi` adquieren relación `:partner`.
  - Flags de estado:
    - `:nick_ogata_rescued => true`
    - `:extortionists_defeated => true`
    - `:adachi_party_joined => true`
    - `:next_step => :enter_underground_sewers`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.scene_transition` (a `pink_street_alley_cry`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:street_extortionists`, data: `{ assisted_by: :adachi, victory: true }`)
- `story.item_acquired` (actor: `:ichiban`, target: `:nick_ogata`, data: `{ item: :nick_ogata_business_card }`)
- `story.party_member_joined` (actor: `:adachi`, target: `:ichiban`, data: `{ role: :partner }`)
- `story.objective_started` (actor: `:ichiban`, data: `{ goal: "infiltrate_through_sewers" }`)
- `story.scenario_completed` (actor: `:ichiban`)
