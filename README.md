# Laboratorio Narrativo: *Yakuza: Like a Dragon* — Capítulos 1, 2 y 3

Simulador narrativo y de continuidad para los tres primeros capítulos (*Light and Shadow*, *Bloody Reunion* y *The Town at Rock Bottom*) de *Yakuza: Like a Dragon*, modelado en Ruby con verificación automatizada de estados, decisiones y eventos.

## Propósito

Este proyecto implementa una arquitectura pedagógica y verificable para simular los dieciocho segmentos clave de los Capítulos 1, 2 y 3:

### Capítulo 1: Light and Shadow (1977 - 2001)
1. `01_origen`: Prólogo de Masumi niño y el origen de la deuda con Toshio (1977).
2. `02_cobranza`: Introducción de Ichiban Kasuga adulto, Mitsuo y la primera cobranza a Ushio (2000).
3. `03_encargo_urgente`: El favor de Michiyo en Shangri-La y el encuentro en la calle.
4. `04_lo_que_se_debe`: La deuda de Koji Hiratsuka en Public Park 3 y la decisión del dinero.
5. `05_el_joven_maestro`: Acompañar a Masato Arakawa al club nocturno y la revelación privada.
6. `06_lo_que_nos_une`: La oficina Arakawa, la cena compartida y los orígenes de ambos protagonistas.
7. `07_el_precio`: La mañana del incidente (2001), ataque Sakaki, la petición de Arakawa y la entrada en prisión.

### Capítulo 2: Bloody Reunion (2019)
8. `08_liberacion`: Liberación de Ichiban tras 18 años, soledad y abordaje del ex-detective Koichi Adachi.
9. `09_el_nuevo_kamurocho`: Retorno al barrio transformado y descubrimiento de la ocupación de la Alianza Omi.
10. `10_rescate_en_la_calle`: Rescate de Nick Ogata de los extorsionadores y unión formal de Adachi al grupo.
11. `11_los_bajos_fondos`: Infiltración a través de los conductos subterráneos de alcantarillado.
12. `12_el_guantelete`: Asalto a la planta ejecutiva de la Omi y combate de jefe contra Jo Sawashiro.
13. `13_reunion_sangrienta`: Cara a cara con Masumi Arakawa, el disparo a quemarropa y el rescate de Yu Nanba en Yokohama.

### Capítulo 3: The Town at Rock Bottom (2019)
14. `14_la_ciudad_en_el_fondo`: Despertar en Isezaki Ijincho junto a Nanba, aprendizaje de supervivencia y permiso del Jefe.
15. `15_la_ley_del_campamento`: Recolección de latas, extorsión de Zheng (Yokohama Liumang) y misterio del billete falso en el bolsillo.
16. `16_en_busca_de_empleo`: Visita a Hello Work, traba burocrática de Ririka y oferta encubierta del Director Kanbe para The Harbor Light.
17. `17_defensa_de_harbor_light`: Guardia nocturna en el bar de Hamako, derrota de Matsuo y desafío abierto al francotirador de Geomijul.
18. `18_un_techo_y_un_ideal`: Confrontación moral con Sota Kume (Bleach Japan), habitación propia con Hamako y promesa de convertirse en Héroe.

---

## Requisitos

- **Ruby**: >= 2.6 (probado en Ruby 2.6.10 estándar).
- **Minitest**: Incluido en la biblioteca estándar de Ruby.
- **Sinatra / WEBrick**: Para el servidor y dashboard web (`gem install sinatra -v '~> 2.2'`).

---

## Tutorial: Servidor Web e Interfaz Gráfica (Sinatra)

El proyecto incluye un dashboard web interactivo construido sobre **Sinatra** que permite ejecutar episodios desde el navegador, inspeccionar eventos y consultar los reportes Markdown renderizados en HTML agrupados por capítulo.

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
  LABORATORIO NARRATIVO — YAKUZA: LIKE A DRAGON (CAPÍTULOS 1 Y 2)
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
3. Verás el **Dashboard de los Capítulos 1 y 2** con la estética urbana inspirada en Kamurocho y Yokohama.

### 3. Funcionalidades del Dashboard

- **Catálogo lateral por capítulos:** Selecciona cualquiera de los trece episodios (`01` a `13`) para ver su sinopsis y contexto.
- **Botón `▶ Ejecutar Episodio`:** Ejecuta el escenario seleccionado de forma determinista y despliega:
  - **Estado Final del Mundo:** Ubicación exacta, periodo temporal, saldo en yenes (¥), inventario de ítems y banderas booleanas activas.
  - **Línea de Tiempo de Eventos:** Cronología secuencial de todos los eventos emitidos con actor, objetivo, escena y datos del payload.
- **Documentación Técnica Integrada:** Accede directamente a las 5 secciones de documentación de cada episodio (`Briefing`, `Escenas`, `Mecánicas`, `Lab` y `AAR`) renderizadas con formato enriquecido.

---

## Uso de la CLI

El runner de línea de comandos se encuentra en `bin/episodio`:

```bash
# Ejecutar cualquier episodio por su identificador (01 a 13)
ruby -Ilib bin/episodio 01
ruby -Ilib bin/episodio 08
ruby -Ilib bin/episodio 13

# Ver ayuda y catálogo completo
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
# Ejecutar todas las pruebas (85 tests, 572 aserciones, 0 fallos)
rake test

# O ejecutar archivos de prueba individuales:
ruby -Ilib -Itest test/test_character.rb
ruby -Ilib -Itest test/test_world_state.rb
ruby -Ilib -Itest test/test_event_log.rb
ruby -Ilib -Itest test/test_scene.rb
ruby -Ilib -Itest test/test_dispatcher.rb
ruby -Ilib -Itest test/test_web_app.rb
ruby -Ilib -Itest test/test_episode_continuity.rb
ruby -Ilib -Itest test/test_chapter2_continuity.rb
ruby -Ilib -Itest test/test_chapter3_continuity.rb
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
├── config.ru                          # Entrypoint Rack para despliegue
├── Procfile                           # Definición de procesos cloud
├── bin/
│   ├── episodio                       # Runner CLI ejecutable (01 a 18)
│   └── servidor                       # Servidor web Sinatra ejecutable (puerto 4567)
├── docs/
│   └── episodios/                     # 90 documentos (ep01 a ep18: briefing, escenas, mecánicas, lab, aar)
├── lib/
│   ├── ichiban_lab.rb                 # Punto de entrada de la gema / librería
│   └── ichiban_lab/                   # Dominio (Character, WorldState, EventLog, Scene, Scenarios, WebApp)
├── prompts/                           # Plantillas y control de estado (ESTADO.txt)
└── test/                              # Suite de pruebas Minitest (85 tests, 572 aserciones)
```
