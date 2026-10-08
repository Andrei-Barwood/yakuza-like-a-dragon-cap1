# Laboratorio del Episodio 61: El ascenso de Aoki

## Guía de Experimentación y Comprobación

```bash
# Ejecución vía CLI
ruby -Ilib bin/episodio 61

# Ejecución de tests específicos
ruby -Ilib -Itest test/test_scenario_ep61.rb
```

## Verificaciones Clave
1. Comprobar que el escenario devuelve éxito con código de salida `0`.
2. Verificar que los eventos canónicos se emiten con sus atributos correctos.
3. Validar el rechazo de ejecución ante precondiciones insatisfechas (`PreconditionError`).
