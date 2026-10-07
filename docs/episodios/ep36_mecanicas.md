# Mecánicas — Episodio 36: El juicio de Tianyou Zhao

## Mecánicas de Dominio

### Aparición de líder de facción y standoff armado
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Exhibición de prueba falsa y evaluación crítica
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

### Tregua condicional y frontera de capítulo hacia Geomijul
- **Implementación:** Modelado semántico mediante estados (`WorldState`), comprobación de precondiciones (`Scene#check_preconditions!`) y registro en `EventLog`.

## Eventos Emitidos
- `story.boss_appearance`
- `story.firearm_standoff`
- `story.deceptive_evidence_revealed`
- `story.internal_suspicion`
- `story.investigative_ultimatum`
- `story.ceasefire_agreed`
- `story.chapter_boundary`
