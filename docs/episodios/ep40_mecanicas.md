# Mecánicas — Episodio 40: La confesión de Nanba

## Mecánicas de Dominio

### Confrontación por historial de espionaje encubierto
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Confesión dramática sobre la desaparición de un hermano
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Ataque con taser no letal y toma de rehenes
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.surveillance_history_revealed`
- `story.confession_unsealed`
- `story.motives_clarified`
- `story.taser_subdual`
- `story.hostage_declared`
