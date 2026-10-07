# Mecánicas — Episodio 35: Camino a Restaurant Row

## Mecánicas de Dominio

### Navegación en zona de guerra urbana activa
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Disparo de disuasión y rechazo de diálogo
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Duelo desarmado por el honor y sumisión no letal de aliado
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.street_battle_crossing`
- `story.gunshot_warning`
- `story.truth_rejected`
- `story.honor_duel_initiated`
- `story.boss_defeated`
