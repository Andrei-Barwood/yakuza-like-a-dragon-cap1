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

## 3. Matriz de Decisiones de Arquitectura

| Aspecto | Decisión Adoptada | Justificación |
|---|---|---|
| **Motor de Dominio** | Modelado semántico propio (`IchibanLab`) sin copiar metáforas ajenas | Respetar fielmente la narrativa urbana y dramática de *Yakuza: Like a Dragon*. |
| **Determinismo** | Secuencias predecibles por defecto con semilla opcional (`--seed`) | Garantiza tests 100% reproducibles sin fragilidad por números aleatorios. |
| **Precondiciones** | Cláusulas explícitas mediante `Scene#check_preconditions!` y `PreconditionError` | Evita fallos silenciosos, defaults enmascarados o transiciones ilegales entre escenas o episodios. |
| **Códigos CLI** | Códigos técnicos `0` (éxito), `2` (fallo de simulación) y `3` (error de uso/id inválido) | Los giros trágicos de la trama (la muerte de Nonomiya) son hechos narrativos, no fallos técnicos. |
| **Economía Narrativa** | Saldos monetarios e inventarios modelados con impacto directo en las transiciones | Permite verificar cuantitativamente las decisiones de supervivencia y progreso social de Ichiban. |
| **Límite Canónico** | Fin cerrado en la tragedia de Otohime Land (Capítulo 4) | Prohíbe inventar mecánicas o adelantar revelaciones del Capítulo 5 en adelante. |

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
│   ├── episodio                             # Runner CLI ejecutable (IDs 01..24)
│   └── servidor                             # Lanzador del servidor web Sinatra en puerto 4567
├── docs/
│   └── episodios/                           # 120 documentos (5 por cada uno de los 24 episodios)
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
│       └── ep24_aar.md ... ep24_mecanicas.md
├── lib/
│   ├── ichiban_lab.rb                       # Entrada de la gema y módulo de errores
│   └── ichiban_lab/
│       ├── character.rb                     # Dominio: Personaje
│       ├── world_state.rb                   # Dominio: Estado de Mundo
│       ├── event_log.rb                     # Dominio: Registro de Eventos
│       ├── scene.rb                         # Dominio: Escenas y Precondiciones
│       ├── manifest.rb                      # Catálogo inmutable de los 24 episodios (Caps 1, 2, 3 y 4)
│       ├── base_scenario.rb                 # Plantilla de orquestación de escenarios
│       ├── web_app.rb                       # Aplicación web Sinatra
│       └── scenarios/
│           ├── ep01.rb ... ep07.rb          # Cap 1: 01_origen hasta 07_el_precio
│           ├── ep08.rb ... ep13.rb          # Cap 2: 08_liberacion hasta 13_reunion_sangrienta
│           ├── ep14.rb ... ep18.rb          # Cap 3: 14_la_ciudad_en_el_fondo hasta 18_un_techo_y_un_ideal
│           ├── ep19.rb                      # Cap 4: 19_el_empleo_prometido
│           ├── ep20.rb                      # Cap 4: 20_otohime_land
│           ├── ep21.rb                      # Cap 4: 21_el_castillo_de_la_luz
│           ├── ep22.rb                      # Cap 4: 22_la_noche_en_survive
│           ├── ep23.rb                      # Cap 4: 23_el_rescate_de_tatsuro
│           └── ep24.rb                      # Cap 4: 24_el_dragon_del_seiryu
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
    ├── test_episode_continuity.rb           # Integración y continuidad Cap 1
    ├── test_chapter2_continuity.rb          # Integración y continuidad Cap 2
    ├── test_chapter3_continuity.rb          # Integración y continuidad Cap 3
    └── test_chapter4_continuity.rb          # Integración y continuidad Cap 4
```

---

## 5. Conclusión

El laboratorio narrativo de los Capítulos 1, 2, 3 y 4 de *Yakuza: Like a Dragon* queda completamente implementado, verificado y documentado. Cumple con todos los criterios de aceptación técnicos y narrativos definidos en los documentos rectores, garantizando determinismo, continuidad comprobable, cobertura exhaustiva de tests automatizados (106 tests, 677 aserciones) e interfaz interactiva tanto por CLI como web.
