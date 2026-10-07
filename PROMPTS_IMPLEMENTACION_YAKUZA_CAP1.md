# Prompts para implementar el laboratorio de *Yakuza: Like a Dragon* — Capítulo 1

Este documento contiene prompts listos para copiar y usar, en orden, para construir el proyecto descrito en [`GUIA_IMPLEMENTACION_YAKUZA_CAP1.md`](./GUIA_IMPLEMENTACION_YAKUZA_CAP1.md). Están pensados para una sesión de programación con acceso al repositorio.

## Cómo usarlos

1. Carga el **Prompt maestro** al inicio de la sesión o inclúyelo en las instrucciones del agente.
2. Ejecuta el **Prompt 00** una vez para establecer las reglas del proyecto y su base técnica.
3. Para cada episodio, copia el **Prompt de episodio**, completa sus variables con la ficha correspondiente y ejecútalo. Trabaja del 01 al 07.
4. Cuando estén listos los siete, ejecuta el **Prompt de integración**.
5. El dashboard es opcional: utiliza su prompt solo después de estabilizar la CLI y la documentación.

No pegues el resumen de Fandom como texto para que sea reescrito. La guía y la referencia enlazada sirven para verificar el alcance; la implementación debe usar descripciones originales, sin copiar diálogos ni texto de la wiki/juego. Si un detalle de canon es dudoso, anótalo como pendiente de verificación en vez de inventarlo.

---

## Prompt maestro

```text
[LABORATORIO NARRATIVO — YAKUZA: LIKE A DRAGON, CAPÍTULO 1]

Actúa como ingeniero/a Ruby, diseñador/a de simulaciones narrativas y
responsable de continuidad. Estás construyendo un laboratorio pequeño y
verificable inspirado en el repositorio descrito en
GUIA_IMPLEMENTACION_YAKUZA_CAP1.md.

ANTES DE CUALQUIER CAMBIO
1. Lee GUIA_IMPLEMENTACION_YAKUZA_CAP1.md completa.
2. Examina los archivos y convenciones que ya existan en el repo.
3. Lee AGENTS.md y prompts/ESTADO.txt si existen; sus instrucciones son
   parte del contrato, salvo que contradigan este prompt o el pedido actual.
4. Respeta cambios preexistentes. No borres ni reemplaces trabajo ajeno.

OBJETIVO DEL PROYECTO
Crear siete escenarios Ruby, uno por segmento del capítulo 1, con estado
explícito, eventos estables, CLI, documentación Markdown y pruebas Minitest.
Es un simulador narrativo acotado, no un port del juego ni un RPG completo.

IDIOMA Y ESTILO
- Documentación, prompts, mensajes de uso y explicación: español.
- Clases, métodos, atributos y nombres de test: inglés.
- Sigue el estilo que ya exista. Si el repositorio está vacío, usa Ruby
  compatible con la versión disponible y Minitest; no añadas gemas sin
  necesidad demostrable.
- Prosa original y concisa. No escribas diálogos canónicos ni reproduzcas
  párrafos de wikis, guiones, subtítulos o materiales oficiales.

MODELO NARRATIVO
- Modela escenas, actores, ubicaciones, objetivos, decisiones y consecuencias.
- No conviertas a personajes en amenazas ni impongas analogías de
  ciberseguridad de NERV.
- Solo representa el estado que afecta transiciones o continuidad.
- Separa reglas del dominio, orquestación del episodio y presentación CLI/Web.
- Escenarios deterministas por defecto. Si introduces azar, inyéctalo y
  permite fijar semilla en tests.
- Eventos estructurados con ids estables, por ejemplo:
  story.objective_started, story.item_acquired,
  story.choice_recorded, story.combat_resolved,
  story.chapter_boundary.
- La ejecución técnica exitosa usa código 0 aunque la historia termine de
  forma trágica. Código 2: error de ejecución/estado imposible. Código 3:
  uso incorrecto o episodio desconocido.

CONTINUIDAD Y ALCANCE
- El capítulo se divide en 01_origen, 02_cobranza, 03_encargo_urgente,
  04_lo_que_se_debe, 05_el_joven_maestro, 06_lo_que_nos_une y 07_el_precio.
- Se permiten variaciones de diseño en decisiones simuladas solo cuando
  la guía las autorice y se documenten como decisiones del laboratorio,
  no como canon del juego.
- El prólogo de Masumi y la línea de Ichiban adulto deben quedar separados.
- Mantén revelaciones y acontecimientos dentro de su episodio; no adelantes
  contenido de capítulos posteriores. El alcance acaba cuando Ichiban entra
  en prisión.
- Trata la página enlazada en la guía como fuente secundaria. No la raspes
  automáticamente ni copies su texto. Señala dudas de canon en docs/ESTADO
  o prompts/ESTADO.txt.

CALIDAD
- Lee suficiente código para respetar los contratos existentes antes de
  editar.
- Tests deben afirmar estados, transiciones y eventos, no solo strings.
- Errores de dominio inválidos deben ser explícitos y verificables; no
  escondas fallos con defaults silenciosos.
- Ejecuta los tests focalizados y los checks existentes relacionados con
  tus cambios. Arregla los fallos causados por el cambio.
- No ejecutes el capítulo completo al requerir un episodio individual,
  excepto en las pruebas de integración.
- No cambies dependencias sin motivo ni generes archivos promocionales.

FORMA DE TRABAJO
- Por defecto, trabaja en un episodio por solicitud.
- Antes de implementar, confirma el alcance leyendo briefing/estado actuales.
- Completa de extremo a extremo solo lo pedido; no implementes episodios
  futuros “por adelantado”.
- Al terminar, actualiza prompts/ESTADO.txt con episodio, fase completada,
  siguiente paso, archivos y bloqueadores.
- En la respuesta final, informa brevemente archivos cambiados y tests
  ejecutados. No afirmes que algo se probó si no se ejecutó.
```

---

## Prompt 00 — Establecer el esqueleto del proyecto

Ejecutar una sola vez en el repo nuevo:

```text
Lee primero GUIA_IMPLEMENTACION_YAKUZA_CAP1.md y el Prompt maestro de
PROMPTS_IMPLEMENTACION_YAKUZA_CAP1.md. Inspecciona el repositorio antes
de cambiar archivos.

Prepara el esqueleto técnico y documental del laboratorio, pero NO
implementes las escenas de los siete episodios todavía.

Entrega:
1. AGENTS.md con las reglas permanentes del Prompt maestro, resumidas sin
   duplicación innecesaria.
2. README.md con propósito, requisitos, ejecución CLI y comandos de test.
3. prompts/ESTADO.txt con estado inicial del proyecto y próximo paso
   (episodio 01, especificación).
4. lib/ichiban_lab.rb y módulos mínimos para:
   - Character: identidad y estado de personaje mínimo, con validación.
   - WorldState: episodio/escena/ubicación, elenco presente, inventario,
     dinero y decisiones solo cuando se necesiten.
   - EventLog: eventos estructurados, ordenados y consultables.
   - Scene: precondiciones/transiciones si son necesarias para una API
     simple y comprensible.
5. test/test_helper.rb y tests unitarios para las invariantes de esos
   objetos.
6. bin/episodio con dispatcher para ids 01–07. Si un episodio aún no está
   implementado, responder de forma explícita y no fingir una simulación.
   Código 0 = escenario ejecutado; 2 = error de ejecución; 3 = uso/id
   inválido.
7. Un manifiesto único del catálogo de siete episodios (puede ser una
   constante Ruby sencilla) que use la CLI y que el dashboard futuro pueda
   reutilizar.

No añadas Sinatra, base de datos, sistema de combate general, minijuegos,
mapa, autenticación ni dependencias salvo que la inspección pruebe que son
necesarios. Mantén el diseño mínimo y extensible por evidencia, no por
anticipación.

Escribe los tests y ejecútalos. Verifica que un id inválido devuelve código
3 y que un episodio todavía inexistente no imprime una falsa ejecución
correcta. Actualiza prompts/ESTADO.txt al terminar.
```

---

## Prompt reutilizable — Implementar un episodio

Copiar este bloque una vez por episodio, sustituyendo todas las variables:

```text
[IMPLEMENTAR EPISODIO {{NN}} — {{SLUG}}]

Lee AGENTS.md, GUIA_IMPLEMENTACION_YAKUZA_CAP1.md,
PROMPTS_IMPLEMENTACION_YAKUZA_CAP1.md y prompts/ESTADO.txt. Examina el
código y tests existentes antes de editar. Mantén intacto trabajo ajeno.

EPISODIO: {{NN}}
SLUG: {{SLUG}}
TÍTULO DE TRABAJO: {{TITULO}}
FASE: {{ESPECIFICACION | IMPLEMENTACION | CIERRE}}

RESUMEN Y LÍMITES DE ESTE EPISODIO:
{{RESUMEN}}

ESTADO FINAL COMPROBABLE:
{{ESTADO_FINAL}}

CONTINUIDAD DE ENTRADA/SALIDA:
{{CONTINUIDAD}}

FASE ESPECIFICACION:
- No implementes Ruby todavía.
- Crea docs/episodios/ep{{NN}}_briefing.md,
  ep{{NN}}_escenas.md y ep{{NN}}_mecanicas.md.
- El briefing fija alcance, fuera de alcance, precondiciones, estado de
  entrada y estado final esperado.
- La secuencia de escenas identifica lugar, participantes, objetivos,
  acciones/transiciones y qué información conoce cada personaje en ese
  punto. No inventes diálogos.
- Las mecánicas especifican decisiones relevantes, precondiciones,
  cambios de estado y eventos estables. Distingue hechos de canon de las
  reglas inventadas para el simulador.
- Termina al cumplir el criterio del episodio; no escribas entregables de
  episodios futuros.

FASE IMPLEMENTACION:
- Implementa el escenario en lib/ichiban_lab/scenarios/ep{{NN}}.rb,
  siguiendo las APIs y convenciones ya establecidas.
- Añade tests/test_scenario_ep{{NN}}.rb y pruebas adicionales solo si
  justifican reglas compartidas.
- Prueba el estado inicial, las transiciones principales, decisiones con
  efectos, eventos relevantes, estado final y errores por precondición
  incumplida.
- Implementa solo las mecánicas descritas en el briefing. No uses output
  textual como única fuente de estado; no simules escenas futuras.
- Conecta el escenario a bin/episodio mediante el manifiesto/catálogo.
- Añade docs/episodios/ep{{NN}}_lab.md con comando, salida orientativa,
  criterios observables y código de salida técnico.

FASE CIERRE:
- Revisa briefing, especificación, implementación y tests buscando
  contradicciones.
- Ejecuta los tests focalizados y corrige los fallos introducidos.
- Comprueba que el CLI ejecuta el episodio y no afecta los demás.
- Añade docs/episodios/ep{{NN}}_aar.md con resultado, discrepancias y
  handoff al episodio siguiente (o cierre del capítulo en el 07).
- Actualiza prompts/ESTADO.txt con fase, archivos, tests y próximo paso.

Si FASE es una sola de las opciones anteriores, ejecuta solo esa fase.
Si el usuario pide explícitamente el episodio completo, realiza
ESPECIFICACION, IMPLEMENTACION y CIERRE en ese orden en esta sesión.
No marques una fase completa si sus criterios no pasan. Si hay dudas de
canon, documéntalas como pendientes en vez de resolverlas por invención.
```

### Fichas para rellenar el prompt de episodio

#### Episodio 01 — `01_origen`

- **Título:** La primera deuda.
- **Resumen:** Prólogo de Masumi niño. Presenta el entorno familiar, su vínculo con Toshio y la muerte violenta de su padre como punto de quiebre. Mantén el corte separado de la línea temporal de Ichiban adulto.
- **Estado final:** Masumi pierde a Toshio y queda establecido el origen de su relación con Arakawa; no se simulan años posteriores.
- **Continuidad:** Entrada independiente de la línea adulta. Su salida es contexto narrativo, no estado jugable que se transfiera automáticamente al escenario 02.
- **Fuera de alcance:** Cualquier escena futura de Ichiban, detalles inventados sobre el agresor o contenido de capítulos posteriores.

#### Episodio 02 — `02_cobranza`

- **Título:** El trabajo del día.
- **Resumen:** Presenta a Ichiban adulto y Mitsuo, la cobranza a Hirotaka Ushio y el combate introductorio. Registra la decisión de devolver a los compradores el dinero recaudado y la reacción de Mitsuo.
- **Estado final:** La cobranza y el combate concluyen; el dinero devuelto y la decisión de Ichiban quedan registrados.
- **Continuidad:** Inicia la línea temporal adulta; establece a Ichiban como miembro de la familia Arakawa y aliado de Mitsuo.
- **Fuera de alcance:** El favor de Michiyo, el encargo de Shangri-La y las cobranzas siguientes.

#### Episodio 03 — `03_encargo_urgente`

- **Título:** Un favor en el barrio.
- **Resumen:** Ichiban recibe el recado de Michiyo sobre Shangri-La, busca un desatascador en la tienda de cigarrillos y protege a un hombre mayor de unos extorsionadores durante el trayecto. Mitsuo anuncia el siguiente trabajo.
- **Estado final:** El problema de Shangri-La queda resuelto; el encuentro callejero y la llamada/encargo de Mitsuo quedan registrados.
- **Continuidad:** Requiere a Ichiban activo en Kamurocho tras el episodio 02; entrega el punto de inicio del episodio 04.
- **Fuera de alcance:** Cobrar a Hiratsuka y cualquier escena de Masato.

#### Episodio 04 — `04_lo_que_se_debe`

- **Título:** Cobrar sin destruir.
- **Resumen:** Ichiban encuentra a Koji Hiratsuka en Public Park 3. La disputa acaba en combate; la historia compartida y la situación familiar de Hiratsuka influyen en cuánto dinero decide llevarse Ichiban.
- **Estado final:** Combate resuelto; se registra que Ichiban toma la cartera, deja parte del dinero y comunica su decisión a Mitsuo.
- **Continuidad:** Requiere el trabajo asignado por Mitsuo en el episodio 03; al finalizar, Sawashiro llama a Ichiban para que atienda a Masato.
- **Fuera de alcance:** Inventar cantidades si el juego no las fija en la fuente consultada; Masato en el club.

#### Episodio 05 — `05_el_joven_maestro`

- **Título:** Una noche para Masato.
- **Resumen:** Ichiban acude a Masato, lo acompaña al club, busca a Yumeno, presencia el conflicto con el cliente Horinouchi y escucha la conversación privada que cambia lo que sabe sobre la relación entre ellos. Masato se marcha y deja su cartera a Ichiban.
- **Estado final:** Masato se ha ido; la cartera/dinero entregado y la información que Ichiban oyó quedan representados sin añadir interpretación omnisciente.
- **Continuidad:** Inicia tras la llamada de Sawashiro al cierre del episodio 04; conduce al regreso a la oficina y la conversación con Arakawa del episodio 06.
- **Fuera de alcance:** Revelaciones de la cena de Arakawa, encarcelamiento y capítulos posteriores.

#### Episodio 06 — `06_lo_que_nos_une`

- **Título:** La familia Arakawa.
- **Resumen:** Ichiban vuelve a la oficina; Sawashiro lo reprende y Arakawa evita que la situación escale. Durante la salida para comer, Arakawa cuenta su historia y Ichiban cuenta cómo llegó a la familia. Cierran la noche tras intervenir en un altercado en Theater Square.
- **Estado final:** La salida termina; quedan establecidas las historias compartidas y la relación entre ambos, sin ejecutar el incidente de la mañana siguiente.
- **Continuidad:** Consume la salida del episodio 05. Deja a Ichiban de vuelta en su apartamento y el tiempo avanza a la mañana del episodio 07.
- **Fuera de alcance:** El ataque de Sakaki, el caso que involucra a Sawashiro y la sentencia.

#### Episodio 07 — `07_el_precio`

- **Título:** Quince años.
- **Resumen:** Ichiban despierta tras un crimen, recibe la llamada de Arakawa y afronta un ataque de la familia Sakaki en camino a la oficina. Arakawa explica la situación y pide a Ichiban que asuma la responsabilidad. Incluye su última comida y su entrega a la policía.
- **Estado final:** Ichiban acepta cargar con el caso y entra en prisión; el capítulo termina. El runner termina técnicamente con éxito.
- **Continuidad:** Consume el cierre nocturno del episodio 06. Es el final del alcance; no crear una continuación jugable.
- **Fuera de alcance:** Cualquier suceso carcelario o argumento del capítulo 2 en adelante.

---

## Prompt de integración — Continuidad y aceptación

Ejecutar cuando los siete episodios estén implementados:

```text
[INTEGRACIÓN DEL CAPÍTULO 1]

Lee AGENTS.md, GUIA_IMPLEMENTACION_YAKUZA_CAP1.md y prompts/ESTADO.txt.
Inspecciona las implementaciones y las pruebas de los episodios 01–07.
No reescribas escenas para “mejorarlas” ni cambies contratos sin evidencia.

Objetivo: verificar y completar la continuidad técnica y documental del
capítulo, desde la línea de Masumi hasta el ingreso de Ichiban en prisión.

1. Añade o completa una prueba de integración que ejecute los episodios
   adultos 02–07 en orden, pasando solo el estado que el contrato define.
   El prólogo 01 debe quedar separado si su estado no es una dependencia
   jugable de la línea adulta.
2. Valida las precondiciones y el estado final de cada episodio; comprueba
   que no se filtren objetos, decisiones ni conocimiento de escenas futuras.
3. Valida el dispatcher: ids 01–07 reconocidos, id desconocido/uso inválido
   devuelve 3, error de ejecución devuelve 2, ejecución narrativa válida
   devuelve 0 aunque el desenlace sea adverso.
4. Comprueba que la documentación de cada episodio concuerde con el
   escenario y sus pruebas; completa solo secciones faltantes relacionadas
   con esta aceptación.
5. No añadas material del capítulo 2 ni texto copiado de fuentes externas.
6. Ejecuta la suite de tests apropiada y reporta exactamente qué comandos
   pasaron/fallaron.
7. Actualiza README.md con el catálogo final y prompts/ESTADO.txt con
   capítulo completo; no borres el historial de decisiones.

Entrega cambios solo donde haya una discrepancia reproducible. No hagas
refactor general ni cambies formato de salida estable sin necesidad.
```

## Prompt opcional — Dashboard y reportes

Usar solo si la interfaz web forma parte del alcance:

```text
[DASHBOARD OPCIONAL DEL CAPÍTULO 1]

Lee AGENTS.md y GUIA_IMPLEMENTACION_YAKUZA_CAP1.md. Inspecciona la CLI,
el manifiesto de episodios y las dependencias existentes antes de editar.
La CLI y los escenarios son la fuente de verdad.

Implementa un dashboard Sinatra mínimo para los siete episodios con:
- selector generado desde el manifiesto compartido;
- acción para ejecutar el episodio y mostrar eventos/estado final;
- enlace a un reporte HTML imprimible basado en los Markdown del episodio;
- mensajes de error explícitos para ids inválidos y fallos de ejecución.

Requisitos:
- No dupliques el catálogo ni las listas de secciones entre rutas y vistas.
- No interpolar valores HTTP en una cadena de shell. Preferir invocar el
  dominio Ruby internamente; si el proceso separado es imprescindible,
  pasar argumentos como array y validar el id con el manifiesto.
- Escapar contenido no confiable en HTML; mantener las plantillas separadas
  de las reglas del dominio.
- El dashboard es una capa opcional y no debe ser requisito para CLI/tests.
- No añadas login, almacenamiento persistente o funciones ajenas al pedido.

Añade tests de rutas/renderizado con las herramientas ya instaladas.
Ejecuta los tests focalizados y actualiza README.md con instrucciones para
levantar la interfaz. No marques el dashboard como funcional si no se pudo
ejecutar y verificar.
```

## Registro de ejecución

| Orden | Prompt | Resultado |
|---:|---|---|
| 1 | Prompt maestro | Instrucciones de sesión cargadas |
| 2 | Prompt 00 | Base del repo |
| 3 | Episodio 01 | Prólogo de Masumi |
| 4 | Episodio 02 | Ichiban y primera cobranza |
| 5 | Episodio 03 | Encargo de Michiyo |
| 6 | Episodio 04 | Deuda de Hiratsuka |
| 7 | Episodio 05 | Masato y Yumeno |
| 8 | Episodio 06 | Arakawa e Ichiban |
| 9 | Episodio 07 | Sacrificio de Ichiban y prisión |
| 10 | Integración | Continuidad, tests y aceptación |
| Opcional | Dashboard | Interfaz y reportes |
