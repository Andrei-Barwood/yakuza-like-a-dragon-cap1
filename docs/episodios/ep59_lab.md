# Laboratorio — Episodio 59: Reencuentro con Mitsuo

## Guía de Verificación Automatizada

### Ejecución CLI
```bash
ruby -Ilib bin/episodio 59
```

### Ejecución de Pruebas Unitarias
```bash
ruby -Ilib -Itest test/test_scenario_ep59.rb
```

### Comprobaciones del Simulador
- **Código de salida:** `0` (éxito técnico).
- **Consistencia de banderas:** Verificación exhaustiva de precondiciones de entrada y banderas de desenlace.
- **Continuidad:** Encadenamiento estricto con `58_el_retorno_de_nanba` y `60_la_promesa_del_pato_de_pekin`.
