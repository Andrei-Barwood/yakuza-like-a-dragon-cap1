# Mecánicas del Episodio 71: La gran batalla de la Omi

## Sistema de Reglas y Dominio
- **Gestión de Estado:** `IchibanLab::WorldState` con flags específicos del Capítulo 12.
- **Emisión de Eventos:** Eventos estables `story.*` con payload descriptivo.
- **Verificación de Precondiciones:** Cláusulas `Scene#add_precondition` garantizando transiciones estrictas.
- **Economía y Pertenencias:** Conservación del inventario y capital del grupo.
