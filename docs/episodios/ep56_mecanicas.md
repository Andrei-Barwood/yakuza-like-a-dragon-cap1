# Mecánicas — Episodio 56: El rescate de Zhao

## Mecánicas de Dominio

### Incorporación de nuevo miembro al grupo (Party Member Join)
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Combate de contención de cazarrecompensas
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Infiltración en bastión criminal
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.party_reinforcement_joined`
- `story.bounty_announced`
- `story.combat_resolved`
- `story.zhao_hostage_confirmed`
- `story.building_infiltrated`
