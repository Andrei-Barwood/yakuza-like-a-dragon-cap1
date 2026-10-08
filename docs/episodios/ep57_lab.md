# Laboratorio — Episodio 57: El dragón y el tigre

## Guía de Verificación Automatizada

### Ejecución CLI
```bash
ruby -Ilib bin/episodio 57
```

### Ejecución de Pruebas Unitarias
```bash
ruby -Ilib -Itest test/test_scenario_ep57.rb
```

### Comprobaciones del Simulador
- **Código de salida:** `0` (éxito técnico).
- **Consistencia de banderas:** Verificación exhaustiva de precondiciones de entrada y banderas de desenlace.
- **Continuidad:** Encadenamiento estricto con `56_el_rescate_de_zhao` y `58_el_retorno_de_nanba`.
