# Mecánicas — Episodio 58: El retorno de Nanba

## Mecánicas de Dominio

### Revancha de jefe (Rematch Boss Encounter)
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Reincorporación permanente de personaje (Permanent Rejoin)
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Sellado de fraternidad inquebrantable
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.lieutenant_duel_initiated`
- `story.nanba_rejoined_combat`
- `story.boss_defeated`
- `story.brotherhood_restored`
- `story.shoichi_marriage_news`
