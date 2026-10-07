# Mecánicas y Reglas de Dominio — Episodio 06: La familia Arakawa (`06_lo_que_nos_une`)

## Decisiones y Precondiciones
- **Precondiciones:**
  - El ingreso a la oficina requiere que la cartera de Masato esté en posesión de Ichiban (`masato_wallet_held => true`).
  - La cena íntima requiere que la intervención de Arakawa se haya producido (`arakawa_intervened => true`).
  - El altercado de Theater Square requiere que la conversación sobre el pasado haya concluido (`shared_past_revealed => true`).
  - El retiro al apartamento requiere que los alborotadores hayan sido dispersados (`theater_square_cleared => true`).
- **Mecánica Financiera e Inventario:**
  - Entrega de la cartera de Masato: se remueve `:masato_wallet` del inventario de Ichiban.
  - Entrega de fondos de cobranza a la caja de la familia: ¥250,000 ingresados a la familia; Ichiban conserva su dinero personal (¥2,000).
- **Relaciones y Flags:**
  - Relación `ichiban` -> `arakawa`: se establece firmemente como `:father_figure`.
  - Relación `arakawa` -> `ichiban`: `:surrogate_son`.
  - Flags de estado:
    - `:funds_deposited => true`
    - `:masato_wallet_returned => true`
    - `:arakawa_intervened => true`
    - `:shared_past_revealed => true`
    - `:theater_square_cleared => true`
    - `:resting_for_night => true`

## Catálogo de Eventos Estables
- `story.scenario_started` (actor: `:ichiban`)
- `story.item_returned` (actor: `:ichiban`, target: `:arakawa`, data: `{ item: :masato_wallet }`)
- `story.funds_deposited` (actor: `:ichiban`, target: `:arakawa_family`, data: `{ amount: 250000 }`)
- `story.conflict_defused` (actor: `:arakawa`, target: `:sawashiro`)
- `story.scene_transition` (a `intimate_dinner_talk`)
- `story.bond_deepened` (actor: `:arakawa`, target: `:ichiban`, data: `{ bond: :father_son_loyalty }`)
- `story.scene_transition` (a `theater_square_brawl`)
- `story.combat_resolved` (actor: `:ichiban`, target: `:delinquents`, data: `{ assisted_by: :arakawa }`)
- `story.scene_transition` (a `apartment_retirement`)
- `story.scenario_completed` (actor: `:ichiban`)
