# Mecánicas — Episodio 34: La chispa del conflicto

## Mecánicas de Dominio

### Comunicación telefónica de crisis y advertencia de inteligencia
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Notificación de bajas de facción aliada
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Deducción táctica y activación de objetivo contra reloj
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.intel_warning_relayed`
- `story.yakuza_murders_reported`
- `story.unauthorized_retaliation`
- `story.conspiracy_deduced`
- `story.objective_started`
