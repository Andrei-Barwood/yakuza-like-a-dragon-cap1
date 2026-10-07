# Laboratorio Narrativo: *Yakuza: Like a Dragon* — Capítulo 1

Simulador narrativo y de continuidad para el primer capítulo (*Light and Shadow*) de *Yakuza: Like a Dragon*, modelado en Ruby con verificación automatizada de estados, decisiones y eventos.

## Propósito

Este proyecto implementa una arquitectura pedagógica y verificable para simular los siete segmentos clave del Capítulo 1:
1. `01_origen`: Prólogo de Masumi niño y el origen de la deuda con Toshio.
2. `02_cobranza`: Introducción de Ichiban Kasuga adulto, Mitsuo y la primera cobranza a Ushio.
3. `03_encargo_urgente`: El favor de Michiyo en Shangri-La y el encuentro en la calle.
4. `04_lo_que_se_debe`: La deuda de Koji Hiratsuka en Public Park 3 y la decisión del dinero.
5. `05_el_joven_maestro`: Acompañar a Masato Arakawa al club nocturno y la revelación privada.
6. `06_lo_que_nos_une`: La oficina Arakawa, la cena compartida y los orígenes de ambos protagonistas.
7. `07_el_precio`: La mañana del incidente, el ataque de los Sakaki, la petición de Arakawa y la entrada en prisión.

## Requisitos

- **Ruby**: >= 2.6 (probado en Ruby 2.6.10 estándar).
- **Minitest**: Incluido en la biblioteca estándar de Ruby.
- **Sinatra / WEBrick**: Para el servidor y dashboard web (`gem install sinatra -v '~> 2.2'`).

---

## Tutorial: Servidor Web e Interfaz Gráfica (Sinatra)

El proyecto incluye un dashboard web interactivo construido sobre **Sinatra** que permite ejecutar episodios desde el navegador, inspeccionar eventos y consultar los reportes Markdown renderizados en HTML.

### 1. Iniciar el servidor

Para levantar el servidor web, ejecuta el script ejecutable incluido en el repositorio:

```bash
# Opción 1: Ejecución directa
bin/servidor

# Opción 2: Invocación explícita mediante Ruby
ruby -Ilib bin/servidor
```

Por defecto, Sinatra se iniciará en el puerto **`4567`**:
```text
======================================================================
  LABORATORIO NARRATIVO — YAKUZA: LIKE A DRAGON (CAPÍTULO 1)
  Servidor Web Sinatra activo en: http://localhost:4567
======================================================================
Presione Ctrl+C para detener el servidor.
```

*(Opcional) Si deseas ejecutarlo en otro puerto, define la variable de entorno `PORT`:*
```bash
PORT=8080 bin/servidor
```

### 2. Visualizar la interfaz en el navegador

1. Abre tu navegador web preferido (Chrome, Firefox, Safari, Edge).
2. Dirígete a la siguiente URL:
   ```text
   http://localhost:4567
   ```
3. Verás el **Dashboard del Capítulo 1** con la estética urbana inspirada en Kamurocho.

### 3. Funcionalidades del Dashboard

- **Catálogo lateral:** Selecciona cualquiera de los siete episodios (`01` a `07`) para ver su sinopsis y contexto.
- **Botón `▶ Ejecutar Episodio`:** Ejecuta el escenario seleccionado de forma determinista y despliega:
  - **Estado Final del Mundo:** Ubicación exacta, periodo temporal, saldo en yenes (¥), inventario de ítems y banderas booleanas activas.
  - **Línea de Tiempo de Eventos:** Cronología secuencial de todos los eventos emitidos con actor, objetivo, escena y datos del payload.
- **Documentación Técnica Integrada:** Accede directamente a las 5 secciones de documentación de cada episodio (`Briefing`, `Escenas`, `Mecánicas`, `Lab` y `AAR`) renderizadas con formato enriquecido.

---

## Uso de la CLI

El runner de línea de comandos se encuentra en `bin/episodio`:

```bash
# Ejecutar un episodio por su identificador (01 a 07)
ruby -Ilib bin/episodio 01
ruby -Ilib bin/episodio 02

# Ver ayuda y catálogo de episodios
ruby -Ilib bin/episodio --help
```

### Códigos de salida CLI

| Código | Significado |
|---|---|
| `0` | Escenario ejecutado con éxito técnico (independientemente del desenlace dramático). |
| `2` | Error de ejecución, estado imposible o episodio no implementado. |
| `3` | Uso incorrecto de argumentos o ID de episodio desconocido. |

---

## Pruebas

Para ejecutar la suite automatizada de pruebas unitarias, de integración y de servidor web:

```bash
# Ejecutar todas las pruebas (46 tests, 306 aserciones)
rake test

# O ejecutar archivos de prueba individuales:
ruby -Ilib -Itest test/test_character.rb
ruby -Ilib -Itest test/test_world_state.rb
ruby -Ilib -Itest test/test_event_log.rb
ruby -Ilib -Itest test/test_scene.rb
ruby -Ilib -Itest test/test_dispatcher.rb
ruby -Ilib -Itest test/test_web_app.rb
ruby -Ilib -Itest test/test_episode_continuity.rb
```

---

## Estructura del Proyecto

```text
.
├── AGENTS.md                          # Reglas para agentes y desarrolladores
├── README.md                          # Este documento
├── BITACORA.md                        # Bitácora detallada del proyecto y registro histórico
├── Gemfile                            # Especificación de dependencias
├── Rakefile                           # Tarea de automatización rake test
├── bin/
│   ├── episodio                       # Runner CLI ejecutable
│   └── servidor                       # Servidor web Sinatra ejecutable (puerto 4567)
├── docs/
│   └── episodios/                     # 35 documentos (briefing, escenas, mecánicas, lab, aar)
├── lib/
│   ├── ichiban_lab.rb                 # Punto de entrada de la gema / librería
│   └── ichiban_lab/                   # Dominio (Character, WorldState, EventLog, Scene, Scenarios, WebApp)
├── prompts/                           # Plantillas y control de estado (ESTADO.txt)
└── test/                              # Suite de pruebas Minitest
```
