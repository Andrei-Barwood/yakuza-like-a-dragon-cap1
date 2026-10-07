# Guía para implementar un laboratorio narrativo de *Yakuza: Like a Dragon* — Capítulo 1

## Propósito

Esta guía describe cómo construir un repositorio inspirado en la arquitectura de `01` para representar, en episodios ejecutables y documentados, el primer capítulo de *Yakuza: Like a Dragon*. El objetivo no es hacer un port del juego ni transcribir su guion: es modelar escenas, objetivos, decisiones, consecuencias y continuidad con Ruby, pruebas automatizadas y documentación.

La fuente de referencia para el alcance y el orden general es el resumen comunitario de [“Light and Shadow”](https://yakuza.fandom.com/wiki/Yakuza:_Like_a_Dragon/Chapter_1). Es una fuente secundaria: validar detalles y cronología contra el juego antes de fijarlos como canon. Usar la página para orientar el análisis, no copiar su redacción, diálogos ni recursos protegidos.

## Lectura del repositorio de referencia

El repo de origen es un laboratorio pedagógico de *Evangelion* organizado alrededor de tres superficies que se refuerzan entre sí:

| Superficie | Implementación actual | Qué se puede reutilizar |
|---|---|---|
| Dominio ejecutable | Ruby bajo `lib/nerv/`: entidades, playbooks, escenarios y eventos SIEM | Separar reglas de dominio, secuencia del episodio y presentación; modelar transiciones que puedan probarse. |
| Progresión por episodios | `lib/nerv/scenarios/epXX.rb`, `lib/nerv/playbooks/epXX.rb`, `bin/episodio` | Cada episodio es una corrida reproducible con estado de entrada, decisiones y resultado explícitos. |
| Evidencia y explicación | `docs/episodios/epXX_*.md`, pruebas Minitest y runner CLI | Escribir primero el contrato narrativo, implementarlo y probar comportamientos, no solo texto impreso. |
| Flujo de autoría | `prompts/`, plantilla reutilizable y `prompts/ESTADO.txt` | Trabajar por secciones y mantener un cursor persistente para continuar de forma ordenada. |
| Consulta visual | Aplicación Sinatra en `lib/magi_web/`, plantillas ERB y JSON | Un dashboard puede ejecutar episodios y reunir documentación en reportes navegables. |

El patrón de calidad más útil es la conexión entre briefing, especificación de comportamiento, implementación y tests: por ejemplo, el contrato del ep 01 declara que el escenario termina sin resolverse, `Nerv::Scenarios::Ep01` orquesta el estado y sus pruebas verifican ese resultado y los eventos producidos.

### Qué cambiar, no copiar

- Reemplazar nombres y metáforas de NERV, Ángeles, AT Field, Eva, MAGI y SIEM por un dominio propio de historia y aventura urbana. Copiar los nombres de clases de NERV dejaría una arquitectura semánticamente falsa.
- No traducir personajes a “amenazas” ni sus conflictos a una kill-chain. El capítulo se presta mejor a modelar escenas, relaciones, encargos, objetos, elecciones y consecuencias.
- El runner actual enumera episodios y códigos de salida explícitamente; el dashboard fija el rango `01..26`, tipos de informe y secciones de Markdown. En la nueva versión, esos contratos deben adaptarse al rango `01..07` y a las secciones elegidas.
- El código de origen es Ruby con Minitest. Sinatra, Kramdown y WEBrick sirven solo si se desea el dashboard; no son necesarios para el núcleo CLI.
- El repo de referencia incluye una plantilla de 12 secciones para sus episodios. Para este alcance conviene una plantilla más corta y una guía maestra que prohíba adelantar sucesos de capítulos posteriores.

## Enfoque de adaptación

Construir un **simulador narrativo de un capítulo**, no un motor completo de RPG:

1. Un episodio recibe un estado inicial (personajes, lugar, hora, relaciones, objetos y objetivos).
2. Ejecuta una secuencia pequeña de escenas y acciones significativas.
3. Registra decisiones y eventos con identificadores estables.
4. Produce un estado final comprobable y un resumen legible.
5. El episodio siguiente puede consumir explícitamente ese estado cuando corresponda.

Mantener las reglas de dominio independientes de la consola y de Sinatra. El texto de presentación puede variar; el resultado de una decisión no debe depender de comparar frases impresas.

### Mapeo conceptual propuesto

| Patrón del repo de referencia | Adaptación al capítulo |
|---|---|
| `ScenarioEpXX` coordina una corrida | `ScenarioEpXX` orquesta las escenas y objetivos de una parte del capítulo. |
| Ángel y Eva como entidades de estado | Personajes con atributos acotados, relaciones, condiciones y pertenencias relevantes. |
| `PlaybookEpXX` como secuencia con resultado | Guion de escena o flujo de objetivos con precondiciones, acciones y consecuencias. |
| SIEM registra eventos técnicos | `EventLog` registra acciones narrativas: objetivo activado/completado, objeto entregado, conversación, combate y cambio de relación. |
| TTPs y controles por episodio | Mecánicas y decisiones distintivas del segmento; no hace falta forzar etiquetas de ciberseguridad. |
| Exit codes indican resultado del incidente | Exit codes indican ejecución correcta/error del simulador. Un final narrativo triste o incompleto no debe parecer fallo técnico. |
| MAGI aporta tres perspectivas | Opcional: evaluadores separados para canon, reglas/continuidad y estado ejecutable. No hace falta conservar el nombre MAGI. |

## División del capítulo en episodios

La división sugerida crea siete unidades con límites claros de alcance y una situación final comprobable. Son cortes de implementación, no afirmaciones de que el juego numere esos segmentos como episodios.

| ID / slug | Título de trabajo | Alcance y objetivo jugable | Estado al cierre |
|---|---|---|---|
| `01_origen` | La primera deuda | Prólogo de Masumi niño: establecer el entorno familiar, el vínculo con Toshio y el asesinato de su padre. Implementar una secuencia corta, sin ramificar en escenas inventadas. | El jugador entiende el origen del vínculo con Arakawa; el incidente queda como punto de quiebre, sin revelar más de lo necesario. |
| `02_cobranza` | El trabajo del día | Presentar a Ichiban adulto, su relación con Mitsuo y la cobranza a Hirotaka Ushio, que introduce el combate. La devolución del dinero a los compradores define una elección de carácter. | Combate y cobranza cerrados; decisión registrada y relación con Mitsuo actualizada. |
| `03_encargo_urgente` | Un favor en el barrio | Seguir el recado de Michiyo al problema de Shangri-La, conseguir un desatascador en la tienda de cigarrillos y proteger a un hombre mayor durante el trayecto. | Encargo resuelto y combate callejero registrado; Mitsuo introduce el siguiente trabajo. |
| `04_lo_que_se_debe` | Cobrar sin destruir | Resolver la deuda de Koji Hiratsuka en el parque. Aunque hay combate, Ichiban reconoce su situación y no le quita todo el dinero. | Combate cerrado; se registra el cobro de la cartera y el dinero que Ichiban decide dejarle. |
| `05_el_joven_maestro` | Una noche para Masato | Recibir la llamada de Sawashiro, acompañar a Masato, buscar a Yumeno y resolver la secuencia del club y la conversación que Ichiban escucha. | Masato se marcha y entrega su cartera a Ichiban para pagar la cuenta; queda registrado lo que Ichiban descubrió. |
| `06_lo_que_nos_une` | La familia Arakawa | Volver a la oficina, resolver la reprimenda, permitir que Arakawa intervenga y desarrollar la conversación de la cena y las historias de ambos. Cerrar con el altercado de Theater Square. | El vínculo Ichiban–Arakawa queda asentado y la noche termina antes del incidente de la mañana siguiente. |
| `07_el_precio` | Quince años | Despertar tras el crimen, recibir el llamado, afrontar el ataque de la familia Sakaki camino a la oficina, conocer la situación de Sawashiro y aceptar cargar con la responsabilidad. Incluir la última comida y la entrega a la policía. | Ichiban entra en prisión; el capítulo termina aquí. No implementar los capítulos siguientes. |

### Límites de continuidad

- Mantener el prólogo de Masumi diferenciado de la línea temporal de Ichiban adulto.
- Cada episodio define explícitamente sus personajes presentes, lugar, momento y estado heredado; no asumir que una escena se puede ejecutar fuera de orden.
- La parte de la cena reúne historias de ambos protagonistas. Mantener esas revelaciones en el episodio 06, en vez de anticiparlas en la ficha inicial de personajes.
- Reservar para el episodio 07 el crimen, la petición de Arakawa y la decisión que lleva a Ichiban a prisión.
- Usar solo el material del capítulo 1. Los puntos de enlace al capítulo 2 pueden anotarse como “fuera de alcance”, sin desarrollarlos.

## Estructura recomendada del nuevo repo

```text
.
├── AGENTS.md
├── README.md
├── Gemfile
├── bin/
│   └── episodio
├── docs/
│   ├── episodios/
│   │   ├── ep01_briefing.md
│   │   ├── ep01_escenas.md
│   │   ├── ep01_mecanicas.md
│   │   ├── ep01_lab.md
│   │   ├── ep01_aar.md
│   │   └── ... archivos equivalentes para ep02–ep07
│   └── tutoriales/
├── lib/
│   ├── ichiban_lab.rb
│   ├── ichiban_lab/
│   │   ├── character.rb
│   │   ├── world_state.rb
│   │   ├── event_log.rb
│   │   ├── scene.rb
│   │   └── scenarios/ep01.rb ... ep07.rb
│   └── web/                  # opcional: dashboard/reportes
├── prompts/
│   ├── 00_GUIA_MAESTRA.txt
│   ├── 01_PLANTILLA_EPISODIO.txt
│   ├── ESTADO.txt
│   └── ep01_origen.txt ... ep07_el_precio.txt
└── test/
    ├── test_helper.rb
    ├── test_world_state.rb
    ├── test_scenario_ep01.rb ... test_scenario_ep07.rb
    └── test_episode_continuity.rb
```

El nombre `IchibanLab` es provisional. Elegir uno antes de generar los archivos y mantenerlo consistente en módulos, comandos, documentación y textos de interfaz.

## Contratos de implementación

### Modelo de dominio mínimo

- **`Character`**: identificador, nombre, atributos usados por reglas, relaciones y pertenencias relevantes. Evitar guardar biografías enteras como campos de estado.
- **`WorldState`**: episodio actual, escena, ubicación, hora, personajes presentes, inventario/dinero necesario para las reglas y banderas de decisiones.
- **`Scene`**: id estable, precondiciones, acciones disponibles y transiciones válidas.
- **`EventLog`**: eventos estructurados como hashes/objetos con `id`, `episode`, `scene`, `actor`, `target` opcional y datos pequeños.
- **`ScenarioEpXX`**: instancia inicial, orquesta escenas, expone `run`, `events` y `outcome` o estado final.

Modelar solo datos que cambien una transición o permitan comprobar continuidad. No intentar reconstruir toda la economía, combate por turnos, mapa explorable, minijuegos o diálogos del videojuego.

### Reglas comprobables

- Las acciones se rechazan si faltan sus precondiciones (por ejemplo, no se puede resolver el encargo sin obtener antes el objeto requerido).
- Los eventos tienen identificadores estables, independientes de cómo se presenten: `story.objective_started`, `story.item_acquired`, `story.choice_recorded`, `story.combat_resolved`, `story.chapter_boundary`.
- Las elecciones cambian el estado o el registro de decisiones de forma observable; no deben ser opciones cosméticas que siempre llevan al mismo estado sin indicarlo.
- La secuencia de cada episodio es determinista por defecto. Si hay aleatoriedad, inyectar una fuente con semilla para que los tests sean reproducibles.
- El fin de una escena y el éxito técnico del runner son conceptos distintos. `0` significa que el escenario se ejecutó correctamente, aunque su desenlace sea adverso para el personaje.

### Pruebas Minitest

Priorizar pruebas de comportamiento:

- Cada escenario termina en el lugar/estado acordado en su briefing y emite los eventos esperados.
- No se puede activar un objetivo antes de cumplir sus precondiciones.
- Una elección de cobranza deja exactamente el saldo o el registro de decisión especificado.
- La adquisición del objeto habilita el siguiente paso del encargo; sin él, la transición falla con un error de dominio claro.
- El episodio 05 conserva la información y los objetos que el episodio 06 espera, sin conceder conocimiento de escenas futuras.
- El episodio 07 cierra el capítulo con Ichiban en prisión y no ejecuta contenido del capítulo 2.
- Una prueba de continuidad ejecuta los episodios en orden y valida el estado transferido entre ellos.

Evitar tests que solo comparen el texto completo de una escena, o que validen canon mediante frases copiadas de una wiki.

## CLI y dashboard

### CLI

Reutilizar la simplicidad de `ruby -Ilib bin/episodio 01`, pero mapear `01..07` a los escenarios nuevos. Salida sugerida: nombre del episodio, eventos legibles y estado final. Definir códigos:

| Código | Significado |
|---:|---|
| `0` | Escenario ejecutado; el resultado narrativo puede ser cualquiera previsto por el briefing. |
| `2` | Error de ejecución o estado imposible del simulador. |
| `3` | Uso incorrecto o episodio desconocido. |

No asignar códigos de error distintos por decisiones morales ni por un final deliberadamente dramático. Añadir pruebas del dispatcher y de episodios inexistentes.

### Web (opcional)

Si se conserva la aplicación Sinatra del repositorio de referencia:

- Mostrar únicamente los siete episodios de este alcance.
- Generar informes a partir de un manifiesto compartido de episodios/secciones, no de listas duplicadas en dashboard, route y plantilla.
- Asociar cada reporte con Markdown existente y tolerar secciones opcionales.
- Ejecutar escenarios mediante una API Ruby interna o un proceso con argumentos separados; no interpolar entrada HTTP en una cadena de shell.
- Mantener textos narrativos en ERB/documentación y la lógica de reglas en `lib/`.

## Flujo de trabajo por episodio

Adaptar el flujo de prompts del repo de origen sin conservar su canon:

1. Escribir en el prompt del episodio el título, cronología, alcance, fuera de alcance, precondiciones y estado final.
2. Crear el briefing antes de código; describir la escena en palabras propias y separar hechos de diseño.
3. Definir actores, estado inicial/final, acciones disponibles y eventos.
4. Implementar reglas mínimas y pruebas del escenario.
5. Añadir el runner y, si corresponde, el reporte.
6. Validar contra el briefing y revisar que no se filtren escenas posteriores.
7. Actualizar `prompts/ESTADO.txt` con episodio activo, sección siguiente, archivos y bloqueadores.

Plantilla documental concisa por episodio:

- `briefing`: propósito, canon incluido, alcance/exclusiones, entrada/salida.
- `escenas`: secuencia, ubicación, participantes y transiciones.
- `mecanicas`: decisiones, precondiciones, efectos de estado y eventos.
- `lab`: comando, salida representativa y criterios observables.
- `aar`: diferencias entre comportamiento esperado y observado, deuda pendiente al episodio siguiente.

El manifiesto del capítulo debe definir qué secciones se esperan en todos los episodios. Si se necesita un documento especial (por ejemplo, reglas de una escena de cobranza), añadirlo como extensión declarada, no como excepción invisible en el dashboard.

## Plan de construcción

1. **Congelar el alcance:** aceptar los siete cortes propuestos o revisarlos antes de crear escenarios.
2. **Crear la base Ruby:** `WorldState`, `EventLog`, `Scene`, helper Minitest y un runner que rechace ids desconocidos.
3. **Construir un episodio vertical:** implementar `01_origen` con briefing, escenario, tests, CLI y reporte básico; validar el patrón antes de multiplicarlo.
4. **Extender episodios 02–07:** conservar solo las abstracciones que el primer escenario probó necesarias; introducir mecánicas cuando aparezcan en la historia.
5. **Añadir continuidad:** pasar estado explícito entre escenarios y ejecutar el capítulo completo en una prueba integradora.
6. **Añadir dashboard y reportes:** después de estabilizar el contrato de CLI y el manifiesto de documentos.
7. **Cerrar capítulo:** verificar límites narrativos, actualizar estado y dejar `07_el_precio` como el último episodio implementado.

## Criterios de aceptación del repo

- Los siete ids ejecutan exactamente un escenario cada uno; entradas inválidas devuelven el código documentado.
- Cada episodio tiene briefing, escenario Ruby y pruebas de estado/transiciones.
- Los episodios se pueden correr individualmente y en secuencia sin compartir estado accidental entre procesos.
- El evento o estado final de cada episodio coincide con su contrato; decisiones narrativas relevantes son verificables.
- El capítulo se cierra en prisión; ninguna implementación requiere inventar acontecimientos del capítulo 2.
- La documentación y la interfaz presentan el mismo catálogo de episodios.
- La redacción es original y el material externo aparece como referencia, no como contenido copiado.

## Referencias

- Repositorio analizado: código y documentación de `01`, en particular `README.md`, `AGENTS.md`, `prompts/00_SESION_MAESTRA.txt`, `prompts/01_PLANTILLA_EPISODIO.txt`, `docs/tutoriales/03_arquitectura.md`, `lib/nerv/scenarios/ep01.rb`, `bin/episodio`, `test/test_scenario_ep01.rb` y `lib/magi_web/`.
- Resumen comunitario del capítulo: [Yakuza: Like a Dragon — Chapter 1](https://yakuza.fandom.com/wiki/Yakuza:_Like_a_Dragon/Chapter_1).
