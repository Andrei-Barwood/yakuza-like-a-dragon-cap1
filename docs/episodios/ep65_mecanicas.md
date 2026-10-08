# Mecánicas del Episodio 65: La noche en Otohime Land

## Sistema de Reglas y Dominio
- **Gestión de Estado:** `IchibanLab::WorldState` con flags específicos del Capítulo 11.
- **Emisión de Eventos:** Eventos estables `story.*` con payload descriptivo.
- **Verificación de Precondiciones:** Cláusulas `Scene#add_precondition` garantizando transiciones estrictas.
- **Economía y Pertenencias:** Conservación del inventario y capital del grupo.
