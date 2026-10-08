# Mecánicas: Episodio EP73 — El dolor en el muelle

## Reglas de Dominio y Validación
Verificación de las banderas de precondición :chapter_12_completed y :arakawa_deceased; emisión del evento story.arakawa_corpse_cordon_rush y story.sawashiro_ishioda_feud.

## Transición de Estado
- Comprobación estricta de precondiciones previas antes de avanzar de escena.
- Actualización inmutable del WorldState con aislamiento de memoria.
