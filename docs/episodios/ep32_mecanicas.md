# Mecánicas — Episodio 32: La fuga subterránea

## Mecánicas de Dominio

### Intervención de aliado enigmático
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Combate en espacios confinados
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Restauración de inventario y bloqueo de comunicaciones
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.mysterious_ally_intervention`
- `story.combat_resolved`
- `story.party_unshackled`
- `story.inventory_recovered`
- `story.comms_offline`
