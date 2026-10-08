# Bitácora del Proyecto: Laboratorio Narrativo *Yakuza: Like a Dragon* — Capítulo 1

**Proyecto:** Laboratorio Narrativo y de Continuidad (*Light and Shadow*)  
**Tecnología:** Ruby (>= 2.6), Minitest, CLI Runner  
**Fecha de finalización:** 2026-10-07  
**Estado:** Capítulo 1 completado e integrado al 100% (42 tests, 290 aserciones, 0 fallos)

---

## 1. Visión y Metodología de Trabajo

Este proyecto implementa un simulador narrativo y de decisiones verificables para el primer capítulo de *Yakuza: Like a Dragon*. A diferencia de un motor RPG genérico o un port del videojuego, el foco está puesto en la comprobación estricta de:
- Estados de mundo (`WorldState`) e identidades de personaje (`Character`).
- Eventos estructurados estables (`EventLog`).
- Precondiciones no ambiguas que rechazan transiciones inválidas (`PreconditionError`).
- Continuidad y handoff encadenado de inventario, dinero y relaciones.
- Aislamiento cronológico estricto entre el prólogo de 1977 y la línea adulta de 2000-2001.

La construcción se guió por el flujo estipulado en `GUIA_IMPLEMENTACION_YAKUZA_CAP1.md` y `PROMPTS_IMPLEMENTACION_YAKUZA_CAP1.md`, avanzando secuencialmente desde el esqueleto del dominio (Prompt 00), por cada uno de los 7 episodios en tres fases disciplinadas (**Especificación -> Implementación -> Cierre**), hasta la **Integración final de Continuidad**.

---

## 2. Registro Cronológico de Fases

### Fase 0: Esqueleto Técnico y Arquitectura de Dominio (Prompt 00)
- **Objetivo:** Establecer los cimientos del repositorio sin adelantar escenas de los episodios.
- **Actividades realizadas:**
  - Redacción de reglas maestras en `AGENTS.md` (idioma de código en inglés, documentación en español, determinismo, códigos CLI 0/2/3).
  - Creación del documento de bienvenida y guía de ejecución en `README.md`.
  - Creación del cursor de estado en `prompts/ESTADO.txt`.
  - Implementación del núcleo de dominio en `lib/ichiban_lab/`:
    - `Character`: Entidad con `id`, `name`, `attributes`, `relationships`, `belongings` y método `deep_clone`.
    - `WorldState`: Estado observable con `episode`, `scene_id`, `location`, `time_period`, `characters`, `inventory`, `money`, `flags` y aislamiento de memoria mediante `deep_clone`.
    - `EventLog` y `Event`: Registro cronológico y estructurado de eventos con capacidades de filtrado por identificador, escena o actores.
    - `Scene`: Definición de escenas con soporte para precondiciones ejecutables (`check_preconditions!`).
    - `Manifest`: Catálogo único e inmutable de los 7 episodios (`01` a `07`).
    - `BaseScenario`: Clase base orquestadora de episodios deterministas con semilla (`seed`).
  - Implementación del runner CLI ejecutable `bin/episodio`.
  - Configuración del entorno de pruebas con `test/test_helper.rb`, `Rakefile` y pruebas unitarias para todas las entidades básicas (`test_character.rb`, `test_world_state.rb`, `test_event_log.rb`, `test_scene.rb`, `test_dispatcher.rb`).
- **Verificación:** Ejecución de 17 tests unitarios iniciales pasando al 100%.

---

### Fase 1: Episodio 01 — `01_origen` ("La primera deuda")
- **Objetivo:** Modelar el prólogo de Masumi Arakawa en su infancia (1977), estableciendo su origen y la muerte de su padre Toshio.
- **Especificación documental:**
  - `docs/episodios/ep01_briefing.md`
  - `docs/episodios/ep01_escenas.md`
  - `docs/episodios/ep01_mecanicas.md`
  - `docs/episodios/ep01_lab.md`
  - `docs/episodios/ep01_aar.md`
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep01.rb`: Escenas `theatre_dressing_room`, `dinner_at_eatery`, `dark_alleyway_ambush`, `prologue_aftermath`.
  - Entrega del objeto `:family_talisman` a Masumi.
  - Asesinato inevitable de Toshio protegiendo a su hijo (`status: :deceased`, HP 0).
  - Masumi adquiere `:trauma => :father_killed` y emite `story.chapter_boundary` con `prologue_1977_end`.
- **Pruebas:** `test/test_scenario_ep01.rb` (ejecución completa, fallo de precondición si no concluye la función previa, y CLI retornando código 0).
- **Handoff:** Aislamiento cronológico estricto; el inventario y fondos de 1977 no se transfieren a la línea adulta.

---

### Fase 2: Episodio 02 — `02_cobranza` ("El trabajo del día")
- **Objetivo:** Iniciar la línea temporal adulta en Kamurocho (año 2000), presentando a Ichiban Kasuga, Mitsuo Yasuda y la primera cobranza a Hirotaka Ushio.
- **Especificación documental:**
  - `docs/episodios/ep02_briefing.md`, `ep02_escenas.md`, `ep02_mecanicas.md`, `ep02_lab.md`, `ep02_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep02.rb`: Escenas `streets_morning_patrol`, `ushio_den_confrontation`, `ushio_combat`, `moral_choice_reimbursement`.
  - Introducción del combate callejero contra Ushio (`status: :defeated`).
  - Decisión moral distintiva de Ichiban: reembolsar ¥50,000 a las víctimas timadas por Ushio y retener ¥200,000 debidos a la familia.
  - Saldo final de dinero: ¥202,000 (¥2,000 iniciales + ¥200,000 recaudados).
  - Vínculo con Mitsuo consolidado como `:loyal_comrade`.
- **Pruebas:** `test/test_scenario_ep02.rb` (validación de precondiciones, cobranza, eventos y CLI).

---

### Fase 3: Episodio 03 — `03_encargo_urgente` ("Un favor en el barrio")
- **Objetivo:** Simular los encargos comunitarios de Ichiban en el barrio: el recado de Michiyo respecto a la fontanería de Shangri-La y el encuentro callejero.
- **Especificación documental:**
  - `docs/episodios/ep03_briefing.md`, `ep03_escenas.md`, `ep03_mecanicas.md`, `ep03_lab.md`, `ep03_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep03.rb`: Escenas `michiyo_request`, `street_skirmish_elderly`, `cigarette_shop_errand`, `shangri_la_resolution`.
  - Intervención callejera en defensa de un anciano frente a matones (`elderly_protected => true`).
  - Adquisición del ítem `:heavy_duty_plunger` en la tienda de cigarrillos.
  - Validación de precondición: Shangri-La exige poseer el desatascador; tras resolver la fontanería, el ítem se consume del inventario.
  - Recepción de la llamada/mensaje de Mitsuo activando el siguiente trabajo: `:next_assignment_target => :hiratsuka`.
- **Pruebas:** `test/test_scenario_ep03.rb` (validación de que la resolución sin desatascador lanza `PreconditionError`).

---

### Fase 4: Episodio 04 — `04_lo_que_se_debe` ("Cobrar sin destruir")
- **Objetivo:** Cobrar la deuda a Koji Hiratsuka en Public Park 3, equilibrando el deber con la compasión hacia un conocido de la infancia.
- **Especificación documental:**
  - `docs/episodios/ep04_briefing.md`, `ep04_escenas.md`, `ep04_mecanicas.md`, `ep04_lab.md`, `ep04_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep04.rb`: Escenas `park_confrontation`, `park_combat`, `wallet_inspection_and_mercy`, `sawashiro_pager_call`.
  - Precondición: El objetivo de cobranza activo debe ser `:hiratsuka`.
  - Combate y sometimiento de Hiratsuka.
  - Decisión con la cartera: contiene ¥100,000; Ichiban retiene ¥50,000 para la familia y le perdona los otros ¥50,000 al ver la difícil situación familiar de Hiratsuka.
  - Saldo acumulado: pasa a ¥252,000.
  - Llamada de Jo Sawashiro convocando a Ichiban para custodiar a Masato (`:sawashiro_summons => true`).
- **Pruebas:** `test/test_scenario_ep04.rb` (saldo, perdonar deuda, llamadas y CLI).

---

### Fase 5: Episodio 05 — `05_el_joven_maestro` ("Una noche para Masato")
- **Objetivo:** Acompañar y proteger a Masato Arakawa ("El Joven Maestro") en silla de ruedas durante su salida al club nocturno de anfitrionas.
- **Especificación documental:**
  - `docs/episodios/ep05_briefing.md`, `ep05_escenas.md`, `ep05_mecanicas.md`, `ep05_lab.md`, `ep05_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep05.rb`: Escenas `escorting_masato`, `hostess_club_lounge`, `overhearing_backstage`, `masato_departure_and_bill`.
  - Precondición de entrada: orden activa de Sawashiro.
  - Tensión con el comisario Horinouchi en el salón VIP.
  - Conversación secreta escuchada por Ichiban: Yumeno revela su desprecio y oportunismo hacia Masato.
  - Masato arroja su cartera a Ichiban y se marcha furioso.
  - Ichiban paga la cuenta del club (¥80,000) con los fondos de la cartera de Masato y conserva la cartera (`:masato_wallet`) en su inventario para rendir cuentas ante el clan.
- **Pruebas:** `test/test_scenario_ep05.rb` (posesión de la cartera de Masato, pago de consumición, salida del joven maestro).

---

### Fase 6: Episodio 06 — `06_lo_que_nos_une` ("La familia Arakawa")
- **Objetivo:** Regreso a la oficina de la familia Arakawa, resolución de la reprimenda, cena íntima entre Arakawa e Ichiban, y recuerdos de lealtad.
- **Especificación documental:**
  - `docs/episodios/ep06_briefing.md`, `ep06_escenas.md`, `ep06_mecanicas.md`, `ep06_lab.md`, `ep06_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep06.rb`: Escenas `office_reprimand`, `intimate_dinner_talk`, `theater_square_brawl`, `apartment_retirement`.
  - Precondición: Ichiban debe portar `:masato_wallet`.
  - Entrega de la cartera a Masumi Arakawa y depósito de los ¥250,000 recaudados en la jornada (remanente personal de Ichiban: ¥2,000).
  - Sawashiro golpea a Ichiban; Arakawa interviene con autoridad paternal.
  - Cena tradicional: revelación de los sacrificios de Arakawa (el dedo cortado para salvar a Ichiban en su juventud) y consolidación de la relación como figura paterna (`:father_figure`).
  - Pacificación conjunta de alborotadores en Theater Square.
  - Retiro a descansar al apartamento en la víspera de Año Nuevo (`resting_for_night => true`).
- **Pruebas:** `test/test_scenario_ep06.rb` (restitución de cartera, depósito de fondos, relación paterno-filial).

---

### Fase 7: Episodio 07 — `07_el_precio` ("Quince años")
- **Objetivo:** Clímax dramático y cierre definitivo del Capítulo 1. El crimen de Sawashiro, la petición de Arakawa, la última comida y el ingreso en prisión.
- **Especificación documental:**
  - `docs/episodios/ep07_briefing.md`, `ep07_escenas.md`, `ep07_mecanicas.md`, `ep07_lab.md`, `ep07_aar.md`.
- **Implementación Ruby:**
  - `lib/ichiban_lab/scenarios/ep07.rb`: Escenas `new_years_awakening`, `sakaki_family_ambush`, `patriarch_solemn_request`, `the_last_meal_and_surrender`.
  - Precondición: descanso completado de la noche anterior.
  - Llamada de emergencia de Arakawa en la mañana del 1 de enero de 2001.
  - Emboscada y combate callejero superado frente a sicarios del clan Sakaki.
  - Revelación privada en la oficina: Sawashiro disparó y mató a un alto mando Sakaki.
  - Petición solemne: Arakawa le ruega a Ichiban que asuma la culpa para salvar a la familia del exterminio. Ichiban acepta el sacrificio por amor y lealtad.
  - Última comida compartida (beef bowl) en silencio solemne.
  - Entrega voluntaria ante la policía: Ichiban pasa a estado `:prisoner`, `:incarcerated`, dinero ¥0 y pertenencias entregadas.
  - Evento de frontera: `story.chapter_boundary` con `chapter: 1`, `status: :concluded`, `next: :out_of_scope`.
- **Pruebas:** `test/test_scenario_ep07.rb` (estado de reclusión, evento de frontera del capítulo, código CLI 0).
- **Límite:** Cierre estricto del alcance sin simular la vida en prisión ni acontecimientos del capítulo 2.

---

### Fase 8: Integración de Continuidad y Aceptación Final
- **Objetivo:** Validar que los escenarios encadenan estado de forma exacta y no fugan información ni suposiciones omniscientes.
- **Pruebas de integración (`test/test_episode_continuity.rb`):**
  1. `test_ep01_prologue_isolation`: Valida que el prólogo de 1977 no interfiere ni es precondición técnica requerida por el inicio del episodio 02.
  2. `test_sequential_adult_continuity_from_ep02_to_ep07`: Ejecuta en cadena los episodios 02 a 07 pasando únicamente el estado formal resultante de cada uno (flujo de fondos: ¥2,000 -> ¥202,000 -> ¥252,000 -> ¥2,000 -> ¥0; inventario; banderas de asignación y relaciones).
  3. `test_all_seven_episodes_executable_via_cli_with_exit_code_0`: Verifica la ejecución por proceso independiente vía `bin/episodio` para cada uno de los 7 identificadores, confirmando salida exitosa (código 0).
- **Pruebas de despacho y códigos de error (`test/test_dispatcher.rb`):**
  - Código `0`: Ejecución normal o comando `--help`.
  - Código `2`: Simulación de fallo de ejecución / precondición rota.
  - Código `3`: Argumentos vacíos o IDs desconocidos (e.g., `99`).
- **Actualización de documentación:**
  - Sincronización de `prompts/ESTADO.txt`.
  - Detalle completo en `README.md`.

---

### Fase 9: Capítulo 2 — "Bloody Reunion" (Episodios 08 a 13)
- **Objetivo:** Extender la arquitectura del laboratorio narrativo para cubrir íntegramente el Capítulo 2 de *Yakuza: Like a Dragon*, dividiéndolo en 6 episodios canónicos que narran la salida de prisión de Ichiban Kasuga en 2019 tras 18 años, el descubrimiento de Kamurocho bajo la Omi Alliance, la alianza con Koichi Adachi, la infiltración de los bajos fondos y el reencuentro dramático con Masumi Arakawa.
- **Episodios implementados:**
  1. **Episodio 08 (`08_liberacion` - "18 años después"):**
     - Liberación en 2019 tras cumplir 18 años (esperaba 15). Nadie de la familia Arakawa lo espera en la puerta salvo el detective Koichi Adachi. Emboscada de matones callejeros superada.
     - Documentación: `docs/episodios/ep08_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep08.rb`.
     - Test: `test/test_scenario_ep08.rb`.
  2. **Episodio 09 (`09_el_nuevo_kamurocho` - "La caída del clan Tojo"):**
     - Kamurocho bajo la hegemonía de la Omi Alliance de Kansai. Visita a la antigua oficina de la familia Arakawa desierta. Combate contra patrulla de la Omi y hallazgo de la pista de la reunión cumbre en Shangri-La.
     - Documentación: `docs/episodios/ep09_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep09.rb`.
     - Test: `test/test_scenario_ep09.rb`.
  3. **Episodio 10 (`10_rescate_en_la_calle` - "Alianza de marginados"):**
     - Rescate de Nick Ogata frente a extorsionadores. Obtención de la tarjeta de contacto de Nick (`:nick_ogata_card`). Pacto formal de grupo con Adachi como compañero de combate permanente (`adachi.party_member = true`).
     - Documentación: `docs/episodios/ep10_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep10.rb`.
     - Test: `test/test_scenario_ep10.rb`.
  4. **Episodio 11 (`11_los_bajos_fondos` - "Infiltración por las cloacas"):**
     - Infiltración a través de los túneles subterráneos de Kamurocho para burlar el cordón policial y de la Omi. Desactivación de guardias y apertura de la escotilla de mantenimiento hacia el sótano del edificio de la reunión.
     - Documentación: `docs/episodios/ep11_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep11.rb`.
     - Test: `test/test_scenario_ep11.rb`.
  5. **Episodio 12 (`12_el_guantelete` - "El enfrentamiento con Sawashiro"):**
     - Asalto a la planta ejecutiva. Duelo de jefes contra Jo Sawashiro, ahora capitán de la Omi Alliance. Victoria táctica de Ichiban y Adachi, desbloqueando el acceso directo a la sala privada de Arakawa.
     - Documentación: `docs/episodios/ep12_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep12.rb`.
     - Test: `test/test_scenario_ep12.rb`.
  6. **Episodio 13 (`13_reunion_sangrienta` - "Reunión sangrienta y despertar en Yokohama"):**
     - Audiencia con Masumi Arakawa en la sala privada. Reacción fría de Arakawa, quien le dispara a quemarropa en el pecho. Ichiban es dado por muerto y arrojado al basurero de Isezaki Ijincho (Yokohama). Rescate quirúrgico de urgencia por el exmédico indigente Yu Nanba.
     - Evento de frontera: `story.chapter_boundary` con `chapter: 2`, `status: :concluded`, `next: :chapter_3`.
     - Documentación: `docs/episodios/ep13_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep13.rb`.
     - Test: `test/test_scenario_ep13.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 2:**
  - `test/test_chapter2_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep07 hasta el Ep13, verificando inventarios, estados de salud, alianzas y el clímax dramático.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `13`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulo 1 y Capítulo 2.
  - Suite de pruebas ejecutada al 100% con éxito: **67 tests, 475 aserciones, 0 fallos, 0 errores**.

---

### Fase 10: Capítulo 3 — "The Town at Rock Bottom" (Episodios 14 a 18)
- **Objetivo:** Ampliar el laboratorio narrativo para cubrir con exactitud el Capítulo 3 de *Yakuza: Like a Dragon* (どん底の街), estructurándolo en 5 episodios canónicos que narran el despertar de Ichiban tras la herida de bala en el basurero de Yokohama, su adaptación al campamento de personas sin hogar junto a Yu Nanba, el descubrimiento de los Tres de Ijin y el billete falso, la búsqueda de empleo en Hello Work, la defensa de The Harbor Light ante la mafia coreana Geomijul y el choque con la ONG puritana Bleach Japan para forjar el ideal del Héroe.
- **Episodios implementados:**
  1. **Episodio 14 (`14_la_ciudad_en_el_fondo` - "La ciudad en el fondo"):**
     - Despertar de Ichiban tres días después en el vertedero de Isezaki Ijincho. Nanba explica la sutura con hilo de pescar y la regla de no llamar la atención. Aprendizaje de la habilidad de rebusque bajo máquinas expendedoras (*Treasure Hunt*), recolección de ¥500 y audiencia con el Jefe del campamento para obtener el permiso de estancia.
     - Documentación: `docs/episodios/ep14_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep14.rb`.
     - Test: `test/test_scenario_ep14.rb`.
  2. **Episodio 15 (`15_la_ley_del_campamento` - "La ley del campamento"):**
     - Rutina de recolección de latas al alba a las 05:30 AM (adquisición de ¥800). Nanba comparte su panecillo. Intrusión de Zheng (Yokohama Liumang) para cobrar extorsión y combate conjunto exitoso. Descubrimiento del billete de ¥10,000 en el bolsillo interior de Ichiban: no presenta orificio de bala, demostrando que fue introducido después del disparo. Revelación del equilibrio de los Tres de Ijin (*Ijin Three*: Yokohama Liumang, Clan Seiryu y Geomijul).
     - Documentación: `docs/episodios/ep15_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep15.rb`.
     - Test: `test/test_scenario_ep15.rb`.
  3. **Episodio 16 (`16_en_busca_de_empleo` - "En busca de empleo"):**
     - Discurso de Ichiban en el campamento para buscar empleo formal y desbloqueo de *Party Chats*. Visita a Hello Work Yokohama. Traba burocrática insalvable ante Ririka por carecer de dirección postal y documentos. Intervención encubierta del Director Shuichi Kanbe, ofreciendo trabajo de guardia nocturna en *The Harbor Light* por ¥5,000.
     - Documentación: `docs/episodios/ep16_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep16.rb`.
     - Test: `test/test_scenario_ep16.rb`.
  4. **Episodio 17 (`17_defensa_de_harbor_light` - "Defensa de The Harbor Light"):**
     - Llegada al bar; Hamako explica el corte del suministro eléctrico que les robaba la mafia Geomijul. Ataque y vandalismo de Matsuo con un mazo de demolición; combate superado. Lluvia de flechas y desafío público de Ichiban ante el francotirador en el tejado, quien le roza la mejilla y se retira impresionado por su valor. Cobro de ¥5,000 y gratitud de Hamako.
     - Documentación: `docs/episodios/ep17_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep17.rb`.
     - Test: `test/test_scenario_ep17.rb`.
  5. **Episodio 18 (`18_un_techo_y_un_ideal` - "Un techo y un ideal"):**
     - Labores de limpieza en el restaurante de Hamako en Sunrise Street. Manifestación de Bleach Japan liderada por Sota Kume contra los locales de la zona gris. Confrontación moral de Ichiban en defensa de las trabajadoras indocumentadas. Combate contra los provocadores de Kume. Hamako les cede una habitación en alquiler en el piso superior para salvaguardar el contrato de arrendamiento. Revelación del pasado de Nanba como enfermero despedido y juramento de Ichiban de convertirse en un auténtico Héroe de videojuego. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 4.
     - Documentación: `docs/episodios/ep18_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep18.rb`.
     - Test: `test/test_scenario_ep18.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 3:**
  - `test/test_chapter3_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep13 (Yokohama, herida en el pecho, salvado por Nanba) a través de los episodios 14 al 18, controlando saldos acumulados (¥0 -> ¥500 -> ¥1,300 -> ¥6,300), inventario con el billete falso, residencia formal y vocación de Héroe.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `18`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1, 2 y 3.
  - Suite de pruebas ejecutada al 100% con éxito: **85 tests, 572 aserciones, 0 fallos, 0 errores**.

---

### Fase 11: Capítulo 4 — "The Dragon of Yokohama" (Episodios 19 a 24)
- **Objetivo:** Ampliar el laboratorio narrativo para cubrir con fidelidad el Capítulo 4 de *Yakuza: Like a Dragon* (横浜の龍), estructurado en 6 episodios canónicos que narran la obtención de empleo formal tras fijar residencia, la investigación de Nanoha Mukoda para Nonomiya en Otohime Land, la infiltración en el asilo Sunlight Castle, el descubrimiento de la trama de eutanasia para cobrar pensiones de la Familia Ryuto (Clan Seiryu), la consolidación en Survive Bar y la confrontación ante el Patriarca Ryuhei Hoshino que culmina con la trágica muerte de Nonomiya.
- **Episodios implementados:**
  1. **Episodio 19 (`19_el_empleo_prometido` - "El empleo prometido"):**
     - Con residencia acreditada en Sunrise Street, Ichiban y Nanba regresan a Hello Work. Registro laboral formal ante Ririka. Reencuentro con Koichi Adachi en el exterior y oferta laboral de Nonomiya para un puesto de investigación en el soapland Otohime Land.
     - Documentación: `docs/episodios/ep19_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep19.rb`.
     - Test: `test/test_scenario_ep19.rb`.
  2. **Episodio 20 (`20_otohime_land` - "La sospecha de Nonomiya"):**
     - Briefing en Otohime Land: Nonomiya sospecha del agotamiento y adelantos de dinero de Nanoha Mukoda. Escucha encubierta en Pocket Café mediante el micrófono/teléfono colocado por Adachi en una maceta. Pista sobre su padre Tatsuro y localización del asilo Sunlight Castle.
     - Documentación: `docs/episodios/ep20_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep20.rb`.
     - Test: `test/test_scenario_ep20.rb`.
  3. **Episodio 21 (`21_el_castillo_de_la_luz` - "Infiltración en Sunlight Castle"):**
     - Contrato externo de contratistas a través del Director Kanbe (Ichiban conserje, Nanba cuidador, Adachi guardia). Gritos aterradores de una anciana en la zona VIP de evacuación. Confirmación del fraude de pensiones orquestado por la Familia Ryuto (filial del Clan Seiryu) y plazo de urgencia para Tatsuro Mukoda.
     - Documentación: `docs/episodios/ep21_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep21.rb`.
     - Test: `test/test_scenario_ep21.rb`.
  4. **Episodio 22 (`22_la_noche_en_survive` - "La noche en Survive Bar"):**
     - Adachi conduce al grupo a Survive Bar en el Bar District. Desbloqueo del hideout y mecánica de *Drink Links*. Diálogo nocturno fraternal entre Ichiban y Adachi consolidando su alianza antes del asalto definitivo matutino.
     - Documentación: `docs/episodios/ep22_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep22.rb`.
     - Test: `test/test_scenario_ep22.rb`.
  5. **Episodio 23 (`23_el_rescate_de_tatsuro` - "El rescate en la sala VIP"):**
     - Asalto a la Excellent Room de Sunlight Castle mediante la tarjeta de acceso de Adachi. Interrupción in extremis al médico a punto de inyectar cloruro de potasio a Tatsuro. Combate y derrota del patriarca de la Familia Ryuto, Yamato Totsuka. Decisión de llevarlo ante la cúpula del Seiryu.
     - Documentación: `docs/episodios/ep23_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep23.rb`.
     - Test: `test/test_scenario_ep23.rb`.
  6. **Episodio 24 (`24_el_dragon_del_seiryu` - "La sede del Seiryu y el precio del silencio"):**
     - Infiltración en el cuartel del Clan Seiryu y rescate acrobático en la ventana. Audiencia con el presidente Ryuhei Hoshino y el capitán Mamoru Takabe. Descubrimiento del billete falso defectuoso que desconcierta a Hoshino. Clausura del asilo y restitución del dinero a Nanoha Mukoda (bono de ¥20,000 para Ichiban). Regreso a Otohime Land y conmoción al encontrar a Nonomiya ahorcado. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 5.
     - Documentación: `docs/episodios/ep24_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep24.rb`.
     - Test: `test/test_scenario_ep24.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 4:**
  - `test/test_chapter4_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep18 hasta el desenlace del Ep24, controlando fondos (¥6,300 a ¥26,300), inventario de tarjetas y llaves, lazos fraternos y shock final.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `24`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1, 2, 3 y 4.
  - Suite de pruebas ejecutada al 100% con éxito: **106 tests, 677 aserciones, 0 fallos, 0 errores**.

---

### Fase 12: Capítulo 5 — "The Liumang's Web" (Episodios 25 a 30)
- **Objetivo:** Ampliar el laboratorio narrativo para cubrir con fidelidad el Capítulo 5 de *Yakuza: Like a Dragon* (流氓の網), estructurado en 6 episodios canónicos que narran la investigación del presunto suicidio de Nonomiya, la incorporación de Saeko Mukoda al equipo, la incursión en Lin Lin Hostess Bar, el desbloqueo del sistema de cambio de oficios en Hello Work, la defensa vecinal ante Bleach Japan y el descubrimiento de la imprenta clandestina de yuanes chinos en el almacén de Yokohama Trading Company que culmina en una explosión en el muelle.
- **Episodios implementados:**
  1. **Episodio 25 (`25_la_heredera_de_otohime` - "La heredera de Otohime"):**
     - Examen forense preliminar de Nonomiya; rechazo a la versión del suicidio y sospecha de homicidio encubierto. Saeko Mukoda se une al grupo (`saeko.party_member = true`). Confesión sobre los pagos extorsivos que Nonomiya enviaba a Akira Mabuchi en Lin Lin Hostess Bar.
     - Documentación: `docs/episodios/ep25_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep25.rb`.
     - Test: `test/test_scenario_ep25.rb`.
  2. **Episodio 26 (`26_el_club_lin_lin` - "Incursión en Lin Lin Hostess Bar"):**
     - Infiltración en Lin Lin; interrogatorio a las empleadas para romper el silencio. Aparición y combate contra Zheng y los matones de Yokohama Liumang. Revelación de que Mabuchi opera a través de Yokohama Trading Company en el muelle de Hamakita.
     - Documentación: `docs/episodios/ep26_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep26.rb`.
     - Test: `test/test_scenario_ep26.rb`.
  3. **Episodio 27 (`27_el_cambio_de_oficio` - "El sistema de oficios y la colocación encubierta"):**
     - Regreso a Hello Work. Ririka introduce el sistema formal de cambio de trabajo (*Job System*). Desbloqueo de oficios específicos (`:hero`, `:homeless_guy`, `:detective`, `:barmaid`). Audiencia con el Director Shuichi Kanbe para obtener colocación encubierta como estibadores nocturnos en el almacén portuario por ¥15,000.
     - Documentación: `docs/episodios/ep27_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep27.rb`.
     - Test: `test/test_scenario_ep27.rb`.
  4. **Episodio 28 (`28_la_resistencia_vecinal` - "La resistencia de Ijincho"):**
     - Sota Kume y los activistas de Bleach Japan intentan vandalizar Otohime Land aprovechando el luto. Intervención contundente de Ichiban y Saeko (bofetada/golpe moral a Kume). Derrota de los alborotadores y muestra masiva de solidaridad del vecindario de Ijincho protegiendo el establecimiento.
     - Documentación: `docs/episodios/ep28_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep28.rb`.
     - Test: `test/test_scenario_ep28.rb`.
  5. **Episodio 29 (`29_la_imprenta_clandestina` - "La imprenta clandestina del muelle"):**
     - Infiltración nocturna al almacén de Yokohama Trading Company en el muelle Hamakita. Desvío de la guardia y descubrimiento en el piso superior de una sofisticada imprenta clandestina de yuanes chinos falsificados (*Counterfeit Yuan Printing Press*). Sustracción de muestras de billetes falsos (`:counterfeit_yuan_sample`).
     - Documentación: `docs/episodios/ep29_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep29.rb`.
     - Test: `test/test_scenario_ep29.rb`.
  6. **Episodio 30 (`30_explosion_en_el_muelle` - "Explosión en el muelle y escape"):**
     - Descuido con un billete caído que delata su presencia. Combate contra el capataz Liumang y refuerzos armados. Nanba provoca la ignición de un camión cisterna para cortar la persecución. Huida exitosa con la evidencia del dinero falso en mano. Avistamiento de una figura misteriosa observándolos en las sombras. Cobro de ¥15,000 (fondos acumulados ¥41,300). Evento de frontera: `story.chapter_boundary` hacia el Capítulo 6.
     - Documentación: `docs/episodios/ep30_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep30.rb`.
     - Test: `test/test_scenario_ep30.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 5:**
  - `test/test_chapter5_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep24 hasta el desenlace del Ep30, controlando fondos (¥26,300 a ¥41,300), inventario de evidencia de falsificación, desbloqueo de oficios, unión definitiva de Saeko y evento de conclusión hacia el Capítulo 6.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `30`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1, 2, 3, 4 y 5.
  - Suite de pruebas ejecutada al 100% con éxito: **127 tests, 771 aserciones, 0 fallos, 0 errores**.

---

### Fase 13: Capítulo 6 — "Ignition" (Episodios 31 a 36)
- **Objetivo:** Ampliar el laboratorio narrativo para cubrir con fidelidad el Capítulo 6 de *Yakuza: Like a Dragon* (戦禍の銃爪), estructurado en 6 episodios canónicos que narran el cautiverio encadenado en el escondite secreto de Mabuchi, la liberación mediante un salvador anónimo, el combate contra la excavadora pesada de Yan en los túneles subterráneos de contrabando, la notificación de asesinatos del Clan Seiryu por el Patriarca Hoshino, la carrera contra reloj a Restaurant Row para someter a golpes a Mamoru Takabe y la intervención definitiva de Tianyou Zhao que desemboca en la pista hacia Geomijul.
- **Episodios implementados:**
  1. **Episodio 31 (`31_el_despertar_encadenado` - "El despertar encadenado"):**
     - Tras la destrucción del almacén, el grupo despierta atado con cadenas en el sótano secreto de Mabuchi. Interrogatorio bajo grabación de video para imputar falsamente al Clan Seiryu la ruptura de la paz territorial. Mabuchi admite haber asesinado a Nonomiya, sube el material a la red para encender la mecha y ordena a Yan ejecutarlos.
     - Documentación: `docs/episodios/ep31_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep31.rb`.
     - Test: `test/test_scenario_ep31.rb`.
  2. **Episodio 32 (`32_la_fuga_subterranea` - "La fuga subterránea"):**
     - Justo antes de que Adachi sea apuñalado, un individuo desconocido corta las cadenas de Ichiban susurrando que el resto depende de él. Kasuga combate a los carceleros, desencadena a Nanba, Adachi y Saeko, y recuperan las cajas con todas sus pertenencias, comprobando que se hallan en una red de túneles sin cobertura de señal telefónica.
     - Documentación: `docs/episodios/ep32_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep32.rb`.
     - Test: `test/test_scenario_ep32.rb`.
  3. **Episodio 33 (`33_el_duelo_de_la_excavadora` - "El duelo de la excavadora"):**
     - Progresión ascendente a través de los túneles de contrabando hacia el nivel B1F. Enfrentamiento contra Yan a bordo de una excavadora de construcción pesada. Inutilización de la máquina, victoria en combate sobre Yan y escape vertical hacia los callejones traseros de Isezaki Ijincho.
     - Documentación: `docs/episodios/ep33_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep33.rb`.
     - Test: `test/test_scenario_ep33.rb`.
  4. **Episodio 34 (`34_la_chispa_del_conflicto` - "La chispa del conflicto"):**
     - Comunicación telefónica con el presidente Ryuhei Hoshino para alertar sobre la provocación de Mabuchi. Hoshino revela que dos subalternos del Seiryu fueron asesinados a tiros en Isezaki Road y que Takabe se dirige en un camión hacia Restaurant Row para cobrarse venganza. Deducción de la maniobra de falsa bandera y activación del objetivo prioritario.
     - Documentación: `docs/episodios/ep34_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep34.rb`.
     - Test: `test/test_scenario_ep34.rb`.
  5. **Episodio 35 (`35_camino_a_restaurant_row` - "Camino a Restaurant Row"):**
     - Incursión en Restaurant Row entre hordas de gánsteres heridos y barricadas urbanas. Disparo de advertencia de Takabe rozando las piernas de Ichiban a las puertas de Qing Jin. Takabe insiste en sacrificar su vida por el honor de sus jóvenes caídos. Ichiban lo desafía a un combate desarmado y lo somete por la fuerza no letal.
     - Documentación: `docs/episodios/ep35_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep35.rb`.
     - Test: `test/test_scenario_ep35.rb`.
  6. **Episodio 36 (`36_el_juicio_de_tianyou_zhao` - "El juicio de Tianyou Zhao"):**
     - Llegada de Tianyou Zhao apuntando con una pistola a Takabe. Zhao exhibe el video manipulado por Mabuchi, pero desconfía de la falta de un motivo claro para la traición de su mano derecha. Al carecer de pruebas irrefutables, Zhao concede una tregua temporal y exige a Kasuga que acuda a la red de espionaje Geomijul para obtener las pruebas concluyentes. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 7.
     - Documentación: `docs/episodios/ep36_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep36.rb`.
     - Test: `test/test_scenario_ep36.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 6:**
  - `test/test_chapter6_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep30 hasta el desenlace del Ep36, controlando inventarios, recuperación de equipamiento, sumisión de Takabe, tregua armada de Zhao y evento de conclusión hacia el Capítulo 7.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `36`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1, 2, 3, 4, 5 y 6.
  - Suite de pruebas ejecutada al 100% con éxito: **148 tests, 869 aserciones, 0 fallos, 0 errores**.

---

### Fase 14: Capítulo 7 — "The Spider's Web" (Episodios 37 a 42)
- **Objetivo:** Extender el laboratorio narrativo para cubrir con fidelidad el Capítulo 7 de *Yakuza: Like a Dragon* (蜘蛛の巣), estructurado en 6 episodios canónicos que narran la incursión en Koreatown tras la tregua de Zhao, el traspaso de la red eléctrica de Geomijul, la revelación de Seonhee y la imprenta clandestina de yenes japoneses, la conmovedora confesión de Yu Nanba sobre su hermano periodista Shoichi, la defensa fraternal de Ichiban ante Joon-gi Han y la cumbre de los Tres de Ijin en Heian Tower junto a Ryuhei Hoshino, Seonhee y Tianyou Zhao.
- **Episodios implementados:**
  1. **Episodio 37 (`37_el_barrio_coreano` - "El barrio coreano y la guía enigmática"):**
     - Tras la tregua concedida por Zhao, el grupo ingresa a Koreatown. Encuentro con una mujer misteriosa que los guía por callejones oscuros hasta la fachada de un edificio decrépito cubierto de intrincados cables eléctricos de alta tensión.
     - Documentación: `docs/episodios/ep37_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep37.rb`.
     - Test: `test/test_scenario_ep37.rb`.
  2. **Episodio 38 (`38_la_fortaleza_electrica` - "La fortaleza eléctrica"):**
     - Cruce de pasarelas suspendidas entre cables de alta tensión y superación de la emboscada de agentes de Geomijul. Son recibidos por Joon-gi Han, su misterioso salvador subterráneo, quien les enseña la red de vigilancia panóptica y la grabación de Mabuchi entrando a Otohime Land antes de la muerte de Nonomiya.
     - Documentación: `docs/episodios/ep38_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep38.rb`.
     - Test: `test/test_scenario_ep38.rb`.
  3. **Episodio 39 (`39_la_reina_de_la_telaraña` - "La reina de la telaraña"):**
     - Ingreso a la imprenta clandestina de yenes falsificados de Geomijul. La guía misteriosa se desvela como Seonhee, la líder suprema de la organización. Explica el pacto del papel importado por Liumang y encañona a Kasuga para exigirle el origen del billete defectuoso de su chaqueta, antes de posar su mirada inquisidora en Nanba.
     - Documentación: `docs/episodios/ep39_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep39.rb`.
     - Test: `test/test_scenario_ep39.rb`.
  4. **Episodio 40 (`40_la_confesion_de_nanba` - "La confesión de Nanba"):**
     - Seonhee expone la vigilancia de medio año de Nanba. Nanba confiesa que fingió ser indigente para investigar la desaparición de su hermano menor, el periodista Shoichi Nanba (alias Shoichi Akiba). Tras pedir que liberen a Kasuga, Seonhee lo electrocuta con un taser y lo toma como rehén hostil.
     - Documentación: `docs/episodios/ep40_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep40.rb`.
     - Test: `test/test_scenario_ep40.rb`.
  5. **Episodio 41 (`41_el_rescate_de_nanba` - "El rescate de Nanba"):**
     - Kasuga defiende el lazo inquebrantable con Nanba ("me salvó la vida y sigue siendo mi camarada"). Combate de jefe contra Joon-gi Han, rescate de Nanba de las garras de Geomijul y huida exitosa. Seonhee profetiza la ruina inminente de Ijincho y convoca a Kasuga a Heian Tower a las 2 AM.
     - Documentación: `docs/episodios/ep41_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep41.rb`.
     - Test: `test/test_scenario_ep41.rb`.
  6. **Episodio 42 (`42_la_cumbre_de_los_tres` - "La cumbre de los Tres de Ijin"):**
     - Examen forense del ordenador portátil de Nanba en el campamento: hallazgo del artículo de Shoichi vinculando los billetes falsos al presidente del CLP, Yutaka Ogikubo. Encuentro en la azotea de Heian Tower con los tres líderes de Ijincho reunidos (Tianyou Zhao, Seonhee y Ryuhei Hoshino), revelándose la verdad detrás del Gran Muro del Músculo. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 8.
     - Documentación: `docs/episodios/ep42_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep42.rb`.
     - Test: `test/test_scenario_ep42.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 7:**
  - `test/test_chapter7_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep36 hasta el desenlace del Ep42, controlando inventarios, rescate de Nanba, notas investigativas de Shoichi, cumbre en Heian Tower y evento de conclusión hacia el Capítulo 8.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `42`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1 al 7.
  - Suite de pruebas ejecutada al 100% con éxito: **169 tests, 972 aserciones, 0 fallos, 0 errores**.

---

### Fase 15: Capítulo 8 — Bleached Black (Episodios 43 a 48)
- **Objetivo:** Modelar los seis episodios clave del Capítulo 8 de *Yakuza: Like a Dragon*, abarcando la revelación histórica del pacto de Ogikubo, el asalto a Bleach Japan, la caída y confesión de Mabuchi, la marcha de Nanba y el impactante descubrimiento de la verdadera identidad del gobernador Ryo Aoki como Masato Arakawa.
- **Episodios implementados:**
  1. **Episodio 43 (`43_el_pacto_de_los_tres` - "El pacto de los Tres de Ijin"):**
     - En el mirador de Heian Tower, Ryuhei Hoshino y Seonhee narran a Kasuga el origen del pacto criminal concebido hace sesenta años por el influyente político Yutaka Ogikubo para financiar a la policía y sostener la zona gris de Ijincho.
     - Documentación: `docs/episodios/ep43_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep43.rb`.
     - Test: `test/test_scenario_ep43.rb`.
  2. **Episodio 44 (`44_el_dilema_de_la_lealtad` - "El dilema de la lealtad"):**
     - Zhao y Hoshino plantean a Kasuga la exigencia de eliminar a Nanba para proteger el secreto de las tres mafias. Ichiban rechaza tajantemente traicionar a su amigo. Joon-gi Han deduce que Nanba buscará asilo en la sede de Bleach Japan en el Edificio Hakuryo.
     - Documentación: `docs/episodios/ep44_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep44.rb`.
     - Test: `test/test_scenario_ep44.rb`.
  3. **Episodio 45 (`45_asalto_al_edificio_hakuryo` - "Asalto al edificio Hakuryo"):**
     - Llegada al Edificio Hakuryo en Carriage Highway. Emboscada por parte del mercenario renegado de Geomijul responsable de la muerte de Matsuo. Tras derrotarlo en combate, el grupo se abre paso al 2F de Bleach Japan.
     - Documentación: `docs/episodios/ep45_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep45.rb`.
     - Test: `test/test_scenario_ep45.rb`.
  4. **Episodio 46 (`46_la_caida_de_mabuchi` - "La caída de Mabuchi"):**
     - Encuentro en el despacho con Nanba y Hajime Ogasawara. Combate de jefe contra Akira Mabuchi. Al ser derrotado, Mabuchi confiesa que Ogasawara ordenó asesinar a Nonomiya y que la Alianza Omi prepara una invasión inminente sobre Yokohama.
     - Documentación: `docs/episodios/ep46_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep46.rb`.
     - Test: `test/test_scenario_ep46.rb`.
  5. **Episodio 47 (`47_la_huida_de_nanba` - "La huida de Nanba"):**
     - Nanba se desmarca del grupo llevándose a rastras a Mabuchi para dar con el paradero de su hermano Shoichi. El grupo inspecciona el despacho de Bleach Japan y halla un recorte con la fotografía de sus fundadores: Hajime Ogasawara y Ryo Aoki.
     - Documentación: `docs/episodios/ep47_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep47.rb`.
     - Test: `test/test_scenario_ep47.rb`.
  6. **Episodio 48 (`48_la_verdadera_identidad_de_aoki` - "La verdadera identidad de Aoki"):**
     - Al examinar la fotografía, Kasuga descubre atónito que el gobernador de Tokio, Ryo Aoki, es en realidad el joven maestro Masato Arakawa. En Tokio, Aoki recibe la llamada de Ogasawara y ordena a la Alianza Omi arrasar Ijincho. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 9.
     - Documentación: `docs/episodios/ep48_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep48.rb`.
     - Test: `test/test_scenario_ep48.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 8:**
  - `test/test_chapter8_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep42 hasta el desenlace del Ep48, controlando inventarios, recorte de prensa de los fundadores, derrota de Mabuchi, revelación de Masato Arakawa y evento de cierre de capítulo hacia el Capítulo 9.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `48`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1 al 8.
  - Suite de pruebas ejecutada al 100% con éxito: **190 tests, 1096 aserciones, 0 fallos, 0 errores**.

---

### Fase 16: Capítulo 9 — House of Cards (Episodios 49 a 54)
- **Objetivo:** Modelar los seis episodios clave del Capítulo 9 de *Yakuza: Like a Dragon*, abarcando el análisis del perfil y ascenso político de Ryo Aoki, el auxilio a Hamako frente a desertores del Seiryu, la invasión multitudinaria de la Omi bajo la máscara de Bleach Japan, la batalla mecánica contra la grúa de Reiji Ishioda, el pasaje secreto en Eomeoni's Vow y el sacrificio de Geomijul en la imprenta en llamas con la captura de Ogasawara.
- **Episodios implementados:**
  1. **Episodio 49 (`49_el_perfil_de_aoki` - "El perfil de Aoki"):**
     - En Survive Bar, Kasuga, Adachi y Saeko desmenuzan el historial público de Ryo Aoki, deduciendo cómo Masato Arakawa se sometió a cirugía motriz en EE.UU., usurpó un registro familiar nuevo y ejecutó el Plan 3K de Kamurocho para erradicar al Clan Tojo con la complicidad del comisionado Horinouchi. El barman autoriza el uso de la planta 2F como cuartel general seguro.
     - Documentación: `docs/episodios/ep49_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep49.rb`.
     - Test: `test/test_scenario_ep49.rb`.
  2. **Episodio 50 (`50_el_contraataque_de_totsuka` - "El contraataque de Totsuka"):**
     - Hamako llama aterrorizada alertando que Totsuka y disidentes armados del Clan Seiryu la acorralan tras revelarse el fraude de los billetes. Kasuga acude al albergue, derrota a Totsuka y a sus hombres, y asegura la protección de su benefactora.
     - Documentación: `docs/episodios/ep50_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep50.rb`.
     - Test: `test/test_scenario_ep50.rb`.
  3. **Episodio 51 (`51_la_marcha_de_los_mil` - "La marcha de los mil"):**
     - Zhao llama alertando sobre mil manifestantes de Bleach Japan —en realidad tropas camufladas de la Alianza Omi— marchando sobre Geomijul. Kasuga intercepta a la vanguardia en Isezaki Road y dispersa a los matones de Kume, quien queda atónito al descubrir que lideraba a miembros de la yakuza.
     - Documentación: `docs/episodios/ep51_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep51.rb`.
     - Test: `test/test_scenario_ep51.rb`.
  4. **Episodio 52 (`52_la_bola_de_demolicion` - "La bola de demolición"):**
     - Reiji Ishioda, lugarteniente de la Omi, asalta la entrada de Geomijul al mando de una grúa con bola de demolición. Reconoce a Kasuga como el superviviente de Kamurocho y libra una feroz batalla mecánica. Kasuga inutiliza la grúa, pero Ishioda colapsa el edificio exterior con un último impacto, obligando al repliegue.
     - Documentación: `docs/episodios/ep52_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep52.rb`.
     - Test: `test/test_scenario_ep52.rb`.
  5. **Episodio 53 (`53_el_voto_de_eomeoni` - "El voto de Eomeoni"):**
     - Joon-gi Han contacta al grupo y los guía al restaurante Eomeoni's Vow, cuyo pasaje subterráneo conecta con la base de Geomijul. Una conmovida Seonhee se inclina pidiendo ganar tiempo para incendiar la imprenta y cumplir la orden de Ogikubo de no dejar pruebas incriminatorias.
     - Documentación: `docs/episodios/ep53_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep53.rb`.
     - Test: `test/test_scenario_ep53.rb`.
  6. **Episodio 54 (`54_el_sacrificio_de_geomijul` - "El sacrificio de Geomijul"):**
     - Con la imprenta ardiendo a sus espaldas, Kasuga resiste la embestida de Ishioda, la Omi y Nanba en una desesperada batalla campal. Tras repeler a los invasores, Seonhee y Joon-gi capturan a Ogasawara y le revelan a Nanba que su hermano Shoichi sigue vivo. El rehén es evacuado al campamento de indigentes. Evento de frontera: `story.chapter_boundary` hacia el Capítulo 10.
     - Documentación: `docs/episodios/ep54_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep54.rb`.
     - Test: `test/test_scenario_ep54.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 9:**
  - `test/test_chapter9_continuity.rb`: Valida el traspaso estricto de estado desde el final del Ep48 hasta el desenlace del Ep54, controlando inventarios, rescate de Hamako, combate contra la grúa de Ishioda, pacto de tierra quemada, captura de Ogasawara y confirmación de Shoichi.
  - Actualización del catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` para abarcar el rango `01` a `54`.
  - Adaptación de la interfaz web Sinatra (`lib/ichiban_lab/web_app.rb`, `views/layout.erb`, `views/index.erb`) para visualizar y simular episodios agrupados por Capítulos 1 al 9.
  - Suite de pruebas ejecutada al 100% con éxito: **211 tests, 1225 aserciones, 0 fallos, 0 errores**.

---

### Fase 17: Capítulo 10 — Justice Bracket (Episodios 55 a 60)
- **Objetivo:** Modelar los seis episodios canónicos del Capítulo 10 (*Justice Bracket* / 恩義の契り): el interrogatorio de Hajime Ogasawara en el campamento, la incorporación de Joon-gi Han, el rescate de Tianyou Zhao en Restaurant Row, la batalla en el cuartel general de Qing Jin contra tigres y la caída de Akira Mabuchi, el duelo mortal contra Reiji Ishioda con el retorno reconciliador de Nanba, el reencuentro privado con Mitsuo Yasuda y traspaso del mando Liumang a Seonhee, la revelación del Jefe sobre el rescate médico de Ichiban, el almuerzo de pato de Pekín con Ryuhei Hoshino en Heian Tower, la verdad sobre el asesinato de Toshio Arakawa en 1977 y el significado del billete defectuoso de 1984.
- **Episodios implementados:**
  1. **Episodio 55 (`55_el_interrogatorio_de_ogasawara` - "El interrogatorio de Ogasawara"):**
     - Ogasawara es interrogado por Kasuga y Nanba en la tienda del campamento; confiesa que Mabuchi planea un golpe de Estado dentro de los Yokohama Liumang derrocando a Zhao. Nanba comprueba que su hermano Shoichi está vivo y a salvo bajo tutela médica de Geomijul y decide ausentarse temporalmente para cuidarlo.
     - Documentación: `docs/episodios/ep55_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep55.rb`.
     - Test: `test/test_scenario_ep55.rb`.
  2. **Episodio 56 (`56_el_rescate_de_zhao` - "El rescate de Zhao"):**
     - Joon-gi Han se incorpora como miembro activo del equipo para auxiliar a Zhao por órdenes de Seonhee. En Restaurant Row son emboscados por Zheng y sicarios que reclaman la recompensa de ¥100 millones puesta por Mabuchi. Tras vencerlos, logran forzar la entrada al cuartel Qing Jin.
     - Documentación: `docs/episodios/ep56_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep56.rb`.
     - Test: `test/test_scenario_ep56.rb`.
  3. **Episodio 57 (`57_el_dragon_y_el_tigre` - "El dragón y el tigre"):**
     - En el patio interior de Qing Jin, Mabuchi libera a dos tigres de combate para devorar al grupo. Kasuga y su equipo vencen a las fieras. Aparecen Yosuke Tendo y Reiji Ishioda, quienes desprecian el fracaso de Mabuchi y lo abandonan. Kasuga derrota definitivamente a Akira Mabuchi cobrando justicia por Nonomiya.
     - Documentación: `docs/episodios/ep57_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep57.rb`.
     - Test: `test/test_scenario_ep57.rb`.
  4. **Episodio 58 (`58_el_retorno_de_nanba` - "El retorno de Nanba"):**
     - Ishioda regresa con armamento pesado y refuerzos de la Omi para eliminar a los testigos. En el momento más crítico del combate, Nanba regresa empuñando su paraguas y fuego, cambiando las tornas de la batalla. Tras derrotar a Ishioda, Kasuga y Nanba sellan su reconciliación con un apretón de manos y Nanba confirma la recuperación de Shoichi.
     - Documentación: `docs/episodios/ep58_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep58.rb`.
     - Test: `test/test_scenario_ep58.rb`.
  5. **Episodio 59 (`59_reencuentro_con_mitsuo` - "Reencuentro con Mitsuo"):**
     - Zhao es liberado de las celdas y agradece a Kasuga; Kasuga se reúne en privado con Mitsuo Yasuda en Survive Bar, quien le relata la situación interna de la Familia Arakawa y la influencia de Aoki. Zhao formaliza la cesión del liderazgo de los Yokohama Liumang a Seonhee para unificar el frente contra la Omi.
     - Documentación: `docs/episodios/ep59_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep59.rb`.
     - Test: `test/test_scenario_ep59.rb`.
  6. **Episodio 60 (`60_la_promesa_del_pato_de_pekin` - "La promesa del pato de Pekín"):**
     - El Jefe del campamento de indigentes confiesa que la supervivencia de Kasuga en el vertedero no fue un milagro al azar, sino un protocolo médico encubierto ordenado por una red secreta. Hoshino invita a Kasuga a un almuerzo de pato de Pekín en Heian Tower; allí revela la verdad sobre el asesinato de Toshio Arakawa en 1977 y el billete defectuoso de 1984 («Ni la justicia ni la piedad deben desbalancear la balanza»). Emisión de frontera `story.chapter_boundary` hacia el Capítulo 11.
     - Documentación: `docs/episodios/ep60_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep60.rb`.
     - Test: `test/test_scenario_ep60.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 10:**
  - `test/test_chapter10_continuity.rb`: Valida el encadenamiento integral desde el final del Ep54 hasta el cierre del Ep60, verificando la partida y regreso de Nanba, incorporación de Joon-gi Han, combates contra tigres, Mabuchi e Ishioda, revelaciones de Mitsuo, confesión del Jefe y almuerzo con Hoshino.
  - Catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` ampliados a los 60 episodios (`01` a `60`).
  - Adaptación del dashboard Sinatra para visualizar y ejecutar los Capítulos 1 al 10 con insignias temáticas.
  - Suite de pruebas ejecutada al 100% con éxito: **232 tests, 1357 aserciones, 0 fallos, 0 errores**.

---

### Fase 18: Capítulo 11 — The Odds (Episodios 61 a 66)
- **Objetivo:** Modelar los seis episodios canónicos del Capítulo 11 (*The Odds* / 喧嘩の勝算): el ascenso de Ryo Aoki a presidente del partido tras el retiro de Ogikubo, la acogida de Zhao y Han en Survive Bar, la trampa electoral de los albergues de Bleach Japan en Hamakita Park con Hamako, el funeral público de Ogasawara con el falso panegírico de Aoki promoviendo a Kume, la infiltración por el montacargas secreto al aparcamiento ribereño y desarticulación de la escolta de la Omi con Adachi, el encuentro nocturno a solas en Otohime Land donde Aoki revela que él mismo asesinó a Suzumori en Nochevieja del 2000, y la emboscada posterior de Sawashiro repelida gracias a Nanba culminando con las lágrimas de Hamako ante la deportación masiva de sus trabajadoras y la declaración de guerra total sin marcha atrás.
- **Episodios implementados:**
  1. **Episodio 61 (`61_el_ascenso_de_aoki` - "El ascenso de Aoki"):**
     - Emisión del noticiero anunciando la renuncia de Ogikubo y el ascenso de Aoki a presidente del CLP. Integración formal de Zhao y Han en Survive Bar y deducción de cómo la Omi eliminó a Ogasawara para crear un mártir político.
     - Documentación: `docs/episodios/ep61_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep61.rb`.
     - Test: `test/test_scenario_ep61.rb`.
  2. **Episodio 62 (`62_el_refugio_de_hamako` - "El refugio de Hamako"):**
     - Hamako convoca al grupo para vaciar Harbor Light; revela que Bleach Japan aloja a sus trabajadoras inmigrantes en Hamakita Park prometiendo visas y formación. Adachi advierte el trasfondo de captación electoral y confirman que Aoki asistirá al funeral de Ogasawara.
     - Documentación: `docs/episodios/ep62_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep62.rb`.
     - Test: `test/test_scenario_ep62.rb`.
  3. **Episodio 63 (`63_el_funeral_de_ogasawara` - "El funeral de Ogasawara"):**
     - En la funeraria de Ijincho, el grupo presencia el panegírico de Aoki con lágrimas de cocodrilo respaldando a Sota Kume al parlamento. Ante el cerco de la prensa, Saeko deduce que Aoki huirá por el aparcamiento subterráneo junto al río.
     - Documentación: `docs/episodios/ep63_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep63.rb`.
     - Test: `test/test_scenario_ep63.rb`.
  4. **Episodio 64 (`64_el_estacionamiento_subterraneo` - "El estacionamiento subterráneo"):**
     - Descenso por el montacargas secreto entre The Harbor Light y Bar Rodriguez. Los falsos guardias de seguridad de Aoki hablan con dialecto de Kansai y son desarmados en combate por Adachi. Aoki reprende a sus hombres y cita a Kasuga a solas en Otohime Land.
     - Documentación: `docs/episodios/ep64_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep64.rb`.
     - Test: `test/test_scenario_ep64.rb`.
  5. **Episodio 65 (`65_la_noche_en_otohime_land` - "La noche en Otohime Land"):**
     - Reunión privada entre Kasuga y Aoki: el trasplante pulmonar en EE.UU., el asesinato de Ogasawara por control de riesgos y la verdad del crimen de Suzumori en Nochevieja del 2000 cometido por Masato. Ruptura de términos y revelación de que el albergue es un plan de deportación masiva.
     - Documentación: `docs/episodios/ep65_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep65.rb`.
     - Test: `test/test_scenario_ep65.rb`.
  6. **Episodio 66 (`66_el_desengano_y_la_resolucion` - "El desengaño y la resolución"):**
     - Aoki envía a Sawashiro y a la Omi para ejecutar a Kasuga; Nanba interviene oportunamente y el grupo derrota a los matones. Hamako llega desesperada confirmando la deportación masiva de sus empleadas. El grupo asume que no hay retorno y declara la guerra total contra Aoki y la Omi. Emisión de frontera `story.chapter_boundary` hacia el Capítulo 12.
     - Documentación: `docs/episodios/ep66_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep66.rb`.
     - Test: `test/test_scenario_ep66.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 11:**
   - `test/test_chapter11_continuity.rb`: Valida el encadenamiento integral desde el final del Ep60 hasta el cierre del Ep66, verificando la integración de Zhao y Han, el programa de refugios, el funeral de Ogasawara, el combate en el parking subterráneo, la revelación del homicidio de Suzumori, el rescate de Nanba, el llanto de Hamako y la resolución de guerra total.
   - Catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` ampliados a los 66 episodios (`01` a `66`).
   - Adaptación del dashboard Sinatra para visualizar y ejecutar los Capítulos 1 al 11 con colores y estilos enriquecidos.
   - Suite de pruebas ejecutada al 100% con éxito: **253 tests, 1496 aserciones, 0 fallos, 0 errores**.

---

### Fase 19: Capítulo 12 — The End of the Yakuza (Episodios 67 a 72)
- **Objetivo:** Modelar los seis episodios canónicos del Capítulo 12 (*The End of the Yakuza* / 極道の終焉): la conspiración entre Ryo Aoki y Jo Sawashiro en el despacho del gobernador enviando a Tendo a Osaka por sospechas hacia Arakawa; el viaje del grupo a Sotenbori y la llamada de Mitsuo revelando la cumbre del Dragon Chamber en el Cabaret Grand; la infiltración encubierta en la sede de la Alianza Omi y el legendario combate de prueba contra Goro Majima y Taiga Saejima detenido por Daigo Dojima y Masumi Arakawa; la revelación del verdadero propósito del Plan 3K, la liberación de Masaru Watase y la proclamación conjunta de disolución del Clan Tojo y la Alianza Omi; la gran batalla campal contra los oficiales rebeldes de la Omi con la épica intervención de Kazuma Kiryu como guardaespaldas de Watase y entrega de documentos a la policía de Osaka; y finalmente la íntima conversación nocturna entre Kasuga y Masumi Arakawa en Hamakita Park seguida por la desgarradora llamada de Hoshino a la mañana siguiente confirmando el asesinato de Arakawa arrojado a las aguas del océano.
- **Episodios implementados:**
  1. **Episodio 67 (`67_el_despacho_del_gobernador` - "El despacho del gobernador"):**
     - En Tokio, Aoki y Sawashiro evalúan la inminente salida de prisión de Masaru Watase. Aoki sospecha de la lealtad de Masumi Arakawa y ordena a Sawashiro desplegar a Yosuke Tendo hacia Osaka para supervisar la ceremonia.
     - Documentación: `docs/episodios/ep67_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep67.rb`.
     - Test: `test/test_scenario_ep67.rb`.
  2. **Episodio 68 (`68_rumbo_a_sotenbori` - "Rumbo a Sotenbori"):**
     - El grupo llega al distrito de Sotenbori en Osaka. Reciben una llamada secreta de Mitsuo desde el Cabaret Grand, advirtiéndoles que la plana mayor de la Omi se congregará en la sede central para el Dragon Chamber; planean infiltración como personal de catering.
     - Documentación: `docs/episodios/ep68_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep68.rb`.
     - Test: `test/test_scenario_ep68.rb`.
  3. **Episodio 69 (`69_los_dragones_legendarios` - "Los dragones legendarios"):**
     - Infiltración en la sede de la Omi en Osaka; enfrentamiento colosal contra los míticos Goro Majima y Taiga Saejima como prueba de valía. Daigo Dojima y Masumi Arakawa detienen el combate, revelándose como aliados secretos coordinados.
     - Documentación: `docs/episodios/ep69_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep69.rb`.
     - Test: `test/test_scenario_ep69.rb`.
  4. **Episodio 70 (`70_el_pacto_de_disolucion` - "El pacto de disolución"):**
     - Liberación penitenciaria de Masaru Watase. En el salón principal de la Omi, Watase y Daigo leen la declaración conjunta de disolución simultánea del Clan Tojo y la Alianza Omi para erradicar el crimen organizado tradicional.
     - Documentación: `docs/episodios/ep70_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep70.rb`.
     - Test: `test/test_scenario_ep70.rb`.
  5. **Episodio 71 (`71_la_gran_batalla_de_la_omi` - "La gran batalla de la Omi"):**
     - Rebelión armada violenta de los lugartenientes de la Omi contrarios a la disolución. Intervención legendaria de Kazuma Kiryu protegiendo a Watase; Kasuga y su grupo barren a los insurrectos y los documentos de disolución son entregados a la policía de Osaka.
     - Documentación: `docs/episodios/ep71_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep71.rb`.
     - Test: `test/test_scenario_ep71.rb`.
  6. **Episodio 72 (`72_la_noche_en_hamakita_y_el_golpe` - "La noche en Hamakita y el golpe"):**
     - Emotivo reencuentro nocturno a solas entre Kasuga y Masumi Arakawa en Hamakita Park; Arakawa explica las razones del disparo de 2001 y su plan de reinserción para ex-yakuza. A la mañana siguiente en Survive Bar, Hoshino llama destrozado: el cuerpo sin vida de Arakawa ha sido hallado en el mar. Emisión de frontera `story.chapter_boundary` hacia el Capítulo 13.
     - Documentación: `docs/episodios/ep72_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep72.rb`.
     - Test: `test/test_scenario_ep72.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 12:**
   - `test/test_chapter12_continuity.rb`: Valida el encadenamiento integral desde el final del Ep66 hasta el cierre del Ep72, verificando el viaje a Sotenbori, infiltración de catering, duelo contra Majima y Saejima, pacto de Watase y Daigo, defensa con Kazuma Kiryu, reencuentro en Hamakita y el hallazgo trágico del cadáver de Arakawa.
   - Catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` ampliados a los 72 episodios (`01` a `72`).
   - Adaptación del dashboard Sinatra para visualizar y ejecutar los Capítulos 1 al 12 con colores morados (`#b388ff`) e insignias carmesí.
   - Suite de pruebas ejecutada al 100% con éxito: **274 tests, 1632 aserciones, 0 fallos, 0 errores**.

---

### Fase 20: Capítulo 13 — Coin Locker Baby (Episodios 73 a 78)
- **Objetivo:** Modelar los seis episodios canónicos del Capítulo 13 (*Coin Locker Baby* / コインロッカーベイビー): la desolación de Kasuga en el muelle de Yokohama tras el hallazgo del cadáver de Masumi Arakawa y la conformación forzada de la Tokyo Omi Alliance por Sawashiro e Ishioda; el duelo contenido en Survive Bar, el relato de Hoshino sobre la cena de pato de Pekín de Arakawa en Heian Tower y el rechazo tajante de Kasuga a la venganza mafiosa armada; el intento de abordar a Kume en Isezaki Road, la fianza electoral de 3 millones de yenes reintegrada por Hoshino y el registro contrarreloj de Kasuga como candidato oficial al Parlamento por el 2º Distrito de Kanagawa; la guerra sucia de carteles de Bleach Japan, el despliegue de la furgoneta electoral de campaña, el mítico debate callejero en Hamakita Park en defensa de las zonas grises humillando a Kume y el ultimátum letal de 24 horas de Aoki a Sawashiro; la aproximación a pie a la Estación de Jinnai, el forzado apretón de manos diplomático ante los medios y la alerta roja de Geomijul por el asalto a los cuarteles del Clan Seiryu; y finalmente la incursión armada en la sede del Seiryu, la muerte del presidente Hoshino a manos de Sawashiro, el duelo cumbre cuerpo a cuerpo y la monumental confesión de Sawashiro sobre la Nochevieja de 1977 revelando que Masato Arakawa (Ryo Aoki) es su propio hijo biológico y que Ichiban Kasuga es el verdadero hijo biológico de Masumi Arakawa y Akane.
- **Episodios implementados:**
  1. **Episodio 73 (`73_el_dolor_en_el_muelle` - "El dolor en el muelle"):**
     - Desesperado intento de Kasuga por alcanzar el cadáver acordonado de Masumi Arakawa en el muelle de Yokohama; reporte de Takabe sobre la última cena con Hoshino y atentados simultáneos en Osaka; en Kamurocho, Sawashiro ejecuta a un subordinado y pacta con Ishioda la creación de la Tokyo Omi Alliance provisional.
     - Documentación: `docs/episodios/ep73_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep73.rb`.
     - Test: `test/test_scenario_ep73.rb`.
  2. **Episodio 74 (`74_el_lamento_y_la_determinacion` - "El lamento y la determinación"):**
     - Apoyado por Zhao en Survive Bar, Kasuga visita a Hoshino en Heian Tower. Hoshino relata la serenidad de Arakawa probando pato de Pekín la noche antes de morir y ofrece el ejército del Seiryu para vengar su muerte. Kasuga rechaza la violencia mafiosa: mantendrá vivo el ideal de Arakawa derrotando políticamente a Aoki con sus propios amigos.
     - Documentación: `docs/episodios/ep74_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep74.rb`.
     - Test: `test/test_scenario_ep74.rb`.
  3. **Episodio 75 (`75_la_candidatura_inesperada` - "La candidatura inesperada"):**
     - Kasuga intenta acercarse a Kume en Isezaki Road y neutraliza a los sicarios encubiertos de la Omi. En la costa, Hoshino le devuelve los 3 millones de yenes de fianza y concibe la estrategia de postular a Kasuga al parlamento por Kanagawa 2nd District para forzar a Kume a interactuar en público. Inscripción oficial in extremis en el edificio Nishihama.
     - Documentación: `docs/episodios/ep75_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep75.rb`.
     - Test: `test/test_scenario_ep75.rb`.
  4. **Episodio 76 (`76_el_debate_en_hamakita` - "El debate en Hamakita"):**
     - Bleach Japan vandaliza Survive Bar; Takabe suministra la furgoneta clásica de campaña de Hoshino. En Hamakita Park, Kasuga desmonta a Kume en un elocuente debate callejero sobre las zonas grises y la dignidad de los desamparados con apoyo de Hamako y el Jefe. Kume huye en ridículo, Kasuga se vuelve viral y Aoki da un ultimátum de 24 horas a Sawashiro.
     - Documentación: `docs/episodios/ep76_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep76.rb`.
     - Test: `test/test_scenario_ep76.rb`.
  5. **Episodio 77 (`77_el_apreton_de_manos_en_jinnai` - "El apretón de manos en Jinnai"):**
     - Desplazamiento a pie a la Estación de Jinnai para sorprender a Kume; combate y neutralización de la guardia de la Tokyo Omi; protocolar apretón de manos frente a las cámaras. Alerta roja urgente de Joon-gi Han: la sede del Seiryu está siendo asaltada por sicarios para asesinar a Hoshino.
     - Documentación: `docs/episodios/ep77_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep77.rb`.
     - Test: `test/test_scenario_ep77.rb`.
  6. **Episodio 78 (`78_los_bebes_de_las_taquillas` - "Los bebés de las taquillas"):**
     - Asalto a la sede del Seiryu, pasillos ensangrentados y encuentro con Takabe herido. En el despacho, hallan a Ryuhei Hoshino asesinado por Jo Sawashiro bajo órdenes de Aoki. Tras un combate a muerte, Sawashiro derrotado desvela el misterio de las taquillas de 1977: Masato Arakawa (Ryo Aoki) es su hijo biológico y Kasuga es el verdadero hijo de Masumi Arakawa y Akane. Emisión de frontera `story.chapter_boundary` hacia el Capítulo 14.
     - Documentación: `docs/episodios/ep78_*.md`.
     - Escenario: `lib/ichiban_lab/scenarios/ep78.rb`.
     - Test: `test/test_scenario_ep78.rb`.
- **Integración de Continuidad y Pruebas del Capítulo 13:**
  - `test/test_chapter13_continuity.rb`: Valida el encadenamiento integral desde el final del Ep72 hasta el cierre del Ep78, verificando el dolor en el muelle, la resolución en Heian Tower, la candidatura de Kasuga, el debate de Hamakita, el apretón de manos en Jinnai, la defensa del Seiryu y la revelación del linaje en las taquillas.
  - Catálogo `IchibanLab::Manifest::EPISODES` y runner `bin/episodio` ampliados a los 78 episodios (`01` a `78`).
  - Adaptación del dashboard Sinatra para visualizar y ejecutar los Capítulos 1 al 13 con colores dorados (`#ffab40`) y distintivos específicos.
  - Suite de pruebas ejecutada al 100% con éxito: **295 tests, 1797 aserciones, 0 fallos, 0 errores**.

---

## 3. Matriz de Decisiones de Arquitectura

| Aspecto | Decisión Adoptada | Justificación |
|---|---|---|
| **Motor de Dominio** | Modelado semántico propio (`IchibanLab`) sin copiar metáforas ajenas | Respetar fielmente la narrativa urbana y dramática de *Yakuza: Like a Dragon*. |
| **Determinismo** | Secuencias predecibles por defecto con semilla opcional (`--seed`) | Garantiza tests 100% reproducibles sin fragilidad por números aleatorios. |
| **Precondiciones** | Cláusulas explícitas mediante `Scene#check_preconditions!` y `PreconditionError` | Evita fallos silenciosos, defaults enmascarados o transiciones ilegales entre escenas o episodios. |
| **Códigos CLI** | Códigos técnicos `0` (éxito), `2` (fallo de simulación) y `3` (error de uso/id inválido) | Los giros dramáticos (la muerte de Hoshino o la verdad de las taquillas) son hechos narrativos, no fallos técnicos. |
| **Economía Narrativa** | Saldos monetarios e inventarios modelados con impacto directo en las transiciones | Permite verificar cuantitativamente las decisiones de supervivencia y progreso cívico de Ichiban. |
| **Límite Canónico** | Fin cerrado en la revelación del linaje de los bebés de las taquillas y la frontera al Capítulo 14 | Prohíbe inventar mecánicas o adelantar revelaciones del Capítulo 14 en adelante. |

---

## 4. Inventario de Archivos Entregados

```text
07 - like a dragon/
├── AGENTS.md                                # Reglas operativas y contratos del simulador
├── README.md                                # Documentación de uso, servidor web Sinatra y tests
├── BITACORA.md                              # Este documento (registro histórico completo)
├── Gemfile                                  # Configuración de dependencias (Rake, Minitest, Sinatra)
├── Rakefile                                 # Tarea por defecto rake test
├── config.ru                                # Entrypoint Rack para servidor y despliegue
├── Procfile                                 # Declaración de proceso web para despliegue
├── bin/
│   ├── episodio                             # Runner CLI ejecutable (IDs 01..78)
│   └── servidor                             # Lanzador del servidor web Sinatra en puerto 4567
├── docs/
│   └── episodios/                           # 390 documentos (5 por cada uno de los 78 episodios)
│       ├── ep01_aar.md ... ep01_mecanicas.md
│       ├── ep02_aar.md ... ep02_mecanicas.md
│       ├── ep03_aar.md ... ep03_mecanicas.md
│       ├── ep04_aar.md ... ep04_mecanicas.md
│       ├── ep05_aar.md ... ep05_mecanicas.md
│       ├── ep06_aar.md ... ep06_mecanicas.md
│       ├── ep07_aar.md ... ep07_mecanicas.md
│       ├── ep08_aar.md ... ep08_mecanicas.md
│       ├── ep09_aar.md ... ep09_mecanicas.md
│       ├── ep10_aar.md ... ep10_mecanicas.md
│       ├── ep11_aar.md ... ep11_mecanicas.md
│       ├── ep12_aar.md ... ep12_mecanicas.md
│       ├── ep13_aar.md ... ep13_mecanicas.md
│       ├── ep14_aar.md ... ep14_mecanicas.md
│       ├── ep15_aar.md ... ep15_mecanicas.md
│       ├── ep16_aar.md ... ep16_mecanicas.md
│       ├── ep17_aar.md ... ep17_mecanicas.md
│       ├── ep18_aar.md ... ep18_mecanicas.md
│       ├── ep19_aar.md ... ep19_mecanicas.md
│       ├── ep20_aar.md ... ep20_mecanicas.md
│       ├── ep21_aar.md ... ep21_mecanicas.md
│       ├── ep22_aar.md ... ep22_mecanicas.md
│       ├── ep23_aar.md ... ep23_mecanicas.md
│       ├── ep24_aar.md ... ep24_mecanicas.md
│       ├── ep25_aar.md ... ep25_mecanicas.md
│       ├── ep26_aar.md ... ep26_mecanicas.md
│       ├── ep27_aar.md ... ep27_mecanicas.md
│       ├── ep28_aar.md ... ep28_mecanicas.md
│       ├── ep29_aar.md ... ep29_mecanicas.md
│       ├── ep30_aar.md ... ep30_mecanicas.md
│       ├── ep31_aar.md ... ep31_mecanicas.md
│       ├── ep32_aar.md ... ep32_mecanicas.md
│       ├── ep33_aar.md ... ep33_mecanicas.md
│       ├── ep34_aar.md ... ep34_mecanicas.md
│       ├── ep35_aar.md ... ep35_mecanicas.md
│       ├── ep36_aar.md ... ep36_mecanicas.md
│       ├── ep37_aar.md ... ep37_mecanicas.md
│       ├── ep38_aar.md ... ep38_mecanicas.md
│       ├── ep39_aar.md ... ep39_mecanicas.md
│       ├── ep40_aar.md ... ep40_mecanicas.md
│       ├── ep41_aar.md ... ep41_mecanicas.md
│       ├── ep42_aar.md ... ep42_mecanicas.md
│       ├── ep43_aar.md ... ep43_mecanicas.md
│       ├── ep44_aar.md ... ep44_mecanicas.md
│       ├── ep45_aar.md ... ep45_mecanicas.md
│       ├── ep46_aar.md ... ep46_mecanicas.md
│       ├── ep47_aar.md ... ep47_mecanicas.md
│       ├── ep48_aar.md ... ep48_mecanicas.md
│       ├── ep49_aar.md ... ep49_mecanicas.md
│       ├── ep50_aar.md ... ep50_mecanicas.md
│       ├── ep51_aar.md ... ep51_mecanicas.md
│       ├── ep52_aar.md ... ep52_mecanicas.md
│       ├── ep53_aar.md ... ep53_mecanicas.md
│       ├── ep54_aar.md ... ep54_mecanicas.md
│       ├── ep55_aar.md ... ep55_mecanicas.md
│       ├── ep56_aar.md ... ep56_mecanicas.md
│       ├── ep57_aar.md ... ep57_mecanicas.md
│       ├── ep58_aar.md ... ep58_mecanicas.md
│       ├── ep59_aar.md ... ep59_mecanicas.md
│       ├── ep60_aar.md ... ep60_mecanicas.md
│       ├── ep61_aar.md ... ep61_mecanicas.md
│       ├── ep62_aar.md ... ep62_mecanicas.md
│       ├── ep63_aar.md ... ep63_mecanicas.md
│       ├── ep64_aar.md ... ep64_mecanicas.md
│       ├── ep65_aar.md ... ep65_mecanicas.md
│       ├── ep66_aar.md ... ep66_mecanicas.md
│       ├── ep67_aar.md ... ep67_mecanicas.md
│       ├── ep68_aar.md ... ep68_mecanicas.md
│       ├── ep69_aar.md ... ep69_mecanicas.md
│       ├── ep70_aar.md ... ep70_mecanicas.md
│       ├── ep71_aar.md ... ep71_mecanicas.md
│       ├── ep72_aar.md ... ep72_mecanicas.md
│       ├── ep73_aar.md ... ep73_mecanicas.md
│       ├── ep74_aar.md ... ep74_mecanicas.md
│       ├── ep75_aar.md ... ep75_mecanicas.md
│       ├── ep76_aar.md ... ep76_mecanicas.md
│       ├── ep77_aar.md ... ep77_mecanicas.md
│       └── ep78_aar.md ... ep78_mecanicas.md
├── lib/
│   ├── ichiban_lab.rb                       # Entrada de la gema y módulo de errores
│   └── ichiban_lab/
│       ├── character.rb                     # Dominio: Personaje
│       ├── world_state.rb                   # Dominio: Estado de Mundo
│       ├── event_log.rb                     # Dominio: Registro de Eventos
│       ├── scene.rb                         # Dominio: Escenas y Precondiciones
│       ├── manifest.rb                      # Catálogo inmutable de los 78 episodios (Caps 1 al 13)
│       ├── base_scenario.rb                 # Plantilla de orquestación de escenarios
│       ├── web_app.rb                       # Aplicación web Sinatra
│       └── scenarios/
│           ├── ep01.rb ... ep07.rb          # Cap 1: 01_origen hasta 07_el_precio
│           ├── ep08.rb ... ep13.rb          # Cap 2: 08_liberacion hasta 13_reunion_sangrienta
│           ├── ep14.rb ... ep18.rb          # Cap 3: 14_la_ciudad_en_el_fondo hasta 18_un_techo_y_un_ideal
│           ├── ep19.rb ... ep24.rb          # Cap 4: 19_el_empleo_prometido hasta 24_el_dragon_del_seiryu
│           ├── ep25.rb ... ep30.rb          # Cap 5: 25_la_heredera_de_otohime hasta 30_explosion_en_el_muelle
│           ├── ep31.rb ... ep36.rb          # Cap 6: 31_el_despertar_encadenado hasta 36_el_juicio_de_tianyou_zhao
│           ├── ep37.rb ... ep42.rb          # Cap 7: 37_el_barrio_coreano hasta 42_la_cumbre_de_los_tres
│           ├── ep43.rb ... ep48.rb          # Cap 8: 43_el_pacto_de_los_tres hasta 48_la_verdadera_identidad_de_aoki
│           ├── ep49.rb ... ep54.rb          # Cap 9: 49_el_perfil_de_aoki hasta 54_el_sacrificio_de_geomijul
│           ├── ep55.rb ... ep60.rb          # Cap 10: 55_el_interrogatorio_de_ogasawara hasta 60_la_promesa_del_pato_de_pekin
│           ├── ep61.rb ... ep66.rb          # Cap 11: 61_el_ascenso_de_aoki hasta 66_el_desengano_y_la_resolucion
│           ├── ep67.rb ... ep72.rb          # Cap 12: 67_el_despacho_del_gobernador hasta 72_la_noche_en_hamakita_y_el_golpe
│           ├── ep73.rb                      # Cap 13: 73_el_dolor_en_el_muelle
│           ├── ep74.rb                      # Cap 13: 74_el_lamento_y_la_determinacion
│           ├── ep75.rb                      # Cap 13: 75_la_candidatura_inesperada
│           ├── ep76.rb                      # Cap 13: 76_el_debate_en_hamakita
│           ├── ep77.rb                      # Cap 13: 77_el_apreton_de_manos_en_jinnai
│           └── ep78.rb                      # Cap 13: 78_los_bebes_de_las_taquillas
├── views/                                   # Vistas ERB para interfaz web Sinatra
│   ├── layout.erb
│   ├── index.erb
│   └── episode.erb
├── prompts/
│   └── ESTADO.txt                           # Cursor de estado persistente del proyecto
└── test/
    ├── test_helper.rb                       # Helper de Minitest
    ├── test_character.rb                    # Tests unitarios de Character
    ├── test_world_state.rb                  # Tests unitarios de WorldState
    ├── test_event_log.rb                    # Tests unitarios de EventLog
    ├── test_scene.rb                        # Tests unitarios de Scene
    ├── test_dispatcher.rb                   # Tests del runner bin/episodio y códigos CLI
    ├── test_web_app.rb                      # Tests de la interfaz web Sinatra
    ├── test_scenario_ep01.rb ... ep07.rb    # Tests unitarios Cap 1
    ├── test_scenario_ep08.rb ... ep13.rb    # Tests unitarios Cap 2
    ├── test_scenario_ep14.rb ... ep18.rb    # Tests unitarios Cap 3
    ├── test_scenario_ep19.rb ... ep24.rb    # Tests unitarios Cap 4
    ├── test_scenario_ep25.rb ... ep30.rb    # Tests unitarios Cap 5
    ├── test_scenario_ep31.rb ... ep36.rb    # Tests unitarios Cap 6
    ├── test_scenario_ep37.rb ... ep42.rb    # Tests unitarios Cap 7
    ├── test_scenario_ep43.rb ... ep48.rb    # Tests unitarios Cap 8
    ├── test_scenario_ep49.rb ... ep54.rb    # Tests unitarios Cap 9
    ├── test_scenario_ep55.rb ... ep60.rb    # Tests unitarios Cap 10
    ├── test_scenario_ep61.rb ... ep66.rb    # Tests unitarios Cap 11
    ├── test_scenario_ep67.rb ... ep72.rb    # Tests unitarios Cap 12
    ├── test_scenario_ep73.rb ... ep78.rb    # Tests unitarios Cap 13
    ├── test_episode_continuity.rb           # Integración y continuidad Cap 1
    ├── test_chapter2_continuity.rb          # Integración y continuidad Cap 2
    ├── test_chapter3_continuity.rb          # Integración y continuidad Cap 3
    ├── test_chapter4_continuity.rb          # Integración y continuidad Cap 4
    ├── test_chapter5_continuity.rb          # Integración y continuidad Cap 5
    ├── test_chapter6_continuity.rb          # Integración y continuidad Cap 6
    ├── test_chapter7_continuity.rb          # Integración y continuidad Cap 7
    ├── test_chapter8_continuity.rb          # Integración y continuidad Cap 8
    ├── test_chapter9_continuity.rb          # Integración y continuidad Cap 9
    ├── test_chapter10_continuity.rb         # Integración y continuidad Cap 10
    ├── test_chapter11_continuity.rb         # Integración y continuidad Cap 11
    ├── test_chapter12_continuity.rb         # Integración y continuidad Cap 12
    └── test_chapter13_continuity.rb         # Integración y continuidad Cap 13
```

---

## 5. Conclusión

El laboratorio narrativo de los Capítulos 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 y 13 de *Yakuza: Like a Dragon* queda completamente implementado, verificado y documentado. Cumple con todos los criterios de aceptación técnicos y narrativos definidos en los documentos rectores, garantizando determinismo, continuidad comprobable, cobertura exhaustiva de tests automatizados (295 tests, 1797 aserciones) e interfaz interactiva tanto por CLI como web.
