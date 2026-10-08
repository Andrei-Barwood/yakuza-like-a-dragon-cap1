# Laboratorio — Episodio 56: El rescate de Zhao

## Guía de Verificación Automatizada

### Ejecución CLI
```bash
ruby -Ilib bin/episodio 56
```

### Ejecución de Pruebas Unitarias
```bash
ruby -Ilib -Itest test/test_scenario_ep56.rb
```

### Comprobaciones del Simulador
- **Código de salida:** `0` (éxito técnico).
- **Consistencia de banderas:** Verificación exhaustiva de precondiciones de entrada y banderas de desenlace.
- **Continuidad:** Encadenamiento estricto con `55_el_interrogatorio_de_ogasawara` y `57_el_dragon_y_el_tigre`.
