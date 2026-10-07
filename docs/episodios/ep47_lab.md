# Laboratorio — Episodio 47: La huida de Nanba

## Guía de Verificación Automatizada

### Ejecución CLI
```bash
ruby -Ilib bin/episodio 47
```

### Ejecución de Pruebas Unitarias
```bash
ruby -Ilib -Itest test/test_scenario_ep47.rb
```

### Comprobaciones del Simulador
- **Código de salida:** `0` (éxito técnico).
- **Consistencia de banderas:** Verificación exhaustiva de precondiciones de entrada y banderas de desenlace.
- **Continuidad:** Encadenamiento estricto con `46_la_caida_de_mabuchi` y `48_la_verdadera_identidad_de_aoki`.
