# Laboratorio — Episodio 55: El interrogatorio de Ogasawara

## Guía de Verificación Automatizada

### Ejecución CLI
```bash
ruby -Ilib bin/episodio 55
```

### Ejecución de Pruebas Unitarias
```bash
ruby -Ilib -Itest test/test_scenario_ep55.rb
```

### Comprobaciones del Simulador
- **Código de salida:** `0` (éxito técnico).
- **Consistencia de banderas:** Verificación exhaustiva de precondiciones de entrada y banderas de desenlace.
- **Continuidad:** Encadenamiento estricto con `54_el_sacrificio_de_geomijul` y `56_el_rescate_de_zhao`.
