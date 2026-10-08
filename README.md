# Laboratorio Narrativo: *Yakuza: Like a Dragon* — Capítulos 1 al 15

Simulador narrativo y de continuidad para los quince capítulos de la campaña completa (*Light and Shadow*, *Bloody Reunion*, *The Town at Rock Bottom*, *The Dragon of Yokohama*, *The Liumang's Web*, *Ignition*, *The Spider's Web*, *Bleached Black*, *House of Cards*, *Justice Bracket*, *The Odds*, *The End of the Yakuza*, *Coin Locker Baby*, *Passing the Torch* y *To the Pinnacle*) de *Yakuza: Like a Dragon*, modelado en Ruby con verificación automatizada de estados, decisiones y eventos.

## Propósito

Este proyecto implementa una arquitectura pedagógica y verificable para simular los noventa segmentos clave de los Capítulos 1 al 15:

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

### Capítulo 4: The Dragon of Yokohama (2019)
19. `19_el_empleo_prometido`: Registro laboral en Hello Work con domicilio legal, reencuentro con Adachi y oferta de Otohime Land.
20. `20_otohime_land`: Encargo de investigar a Nanoha Mukoda, escucha encubierta en Pocket Café y localización de Sunlight Castle.
21. `21_el_castillo_de_la_luz`: Infiltración como contratistas, gritos en la sala VIP y descubrimiento del fraude de pensiones de la Familia Ryuto.
22. `22_la_noche_en_survive`: Base de operaciones en Survive Bar, mecánica Drink Links y plan de rescate para Tatsuro Mukoda.
23. `23_el_rescate_de_tatsuro`: Asalto a la sala VIP, detención in extremis de la inyección letal de cloruro de potasio y derrota de Totsuka.
24. `24_el_dragon_del_seiryu`: Audiencia con Ryuhei Hoshino, el billete defectuoso, restitución a Nanoha y hallazgo del cadáver de Nonomiya.

### Capítulo 5: The Liumang's Web (2019)
25. `25_la_heredera_de_otohime`: Muerte de Nonomiya, Saeko Mukoda se une al grupo y pista de Akira Mabuchi en Lin Lin Hostess Bar.
26. `26_el_club_lin_lin`: Entrada en Lin Lin, interrogatorio a las anfitrionas, derrota de Zheng y revelación de Yokohama Trading Company.
27. `27_el_cambio_de_oficio`: Sistema de empleos de Hello Work con Ririka, desbloqueo de oficios y colocación encubierta en el muelle de Hamakita con Kanbe.
28. `28_la_resistencia_vecinal`: Protesta de Bleach Japan ante Otohime Land, humillación de Sota Kume y solidaridad de la comunidad de Ijincho.
29. `29_la_imprenta_clandestina`: Infiltración al almacén, hallazgo de la imprenta clandestina de yuanes chinos y obtención de billetes de muestra.
30. `30_explosion_en_el_muelle`: Alerta por el billete caído, combate contra el capataz Liumang, explosión de camión cisterna, escape con evidencia y avistamiento del observador misterioso.

### Capítulo 6: Ignition (2019)
31. `31_el_despertar_encadenado`: Despertar maniatados con cadenas en el sótano secreto de Mabuchi, interrogatorio forzado grabado y confesión del homicidio de Nonomiya.
32. `32_la_fuga_subterranea`: Intervención del salvador misterioso, derrota de carceleros, liberación del grupo y recuperación del equipamiento en zona sin señal telefónica.
33. `33_el_duelo_de_la_excavadora`: Ascenso por la ruta subterránea de contrabando hacia B1F, batalla de jefe contra Yan al mando de la excavadora pesada y salida a la superficie.
34. `34_la_chispa_del_conflicto`: Contacto telefónico con el Patriarca Hoshino, aviso de asesinatos callejeros en Isezaki Road, ofensiva descontrolada de Takabe y deducción de la trampa.
35. `35_camino_a_restaurant_row`: Travesía por el campo de batalla urbano en Restaurant Row, disparo intimidatorio en la entrada de Qing Jin y combate a puño limpio con Takabe.
36. `36_el_juicio_de_tianyou_zhao`: Intervención de Tianyou Zhao con pistola en mano, confrontación con el video editado por Mabuchi, tregua armada y ultimátum para conseguir pruebas en Geomijul.

### Capítulo 7: The Spider's Web (2019)
37. `37_el_barrio_coreano`: Incursión en Koreatown para buscar a Geomijul, encuentro con la mujer misteriosa y llegada a la fachada de cables.
38. `38_la_fortaleza_electrica`: Traspaso de cables de alta tensión, reencuentro con Joon-gi Han y confirmación del video de Mabuchi entrando a Otohime Land.
39. `39_la_reina_de_la_telaraña`: Imprenta clandestina de yenes, aparición de Seonhee como líder suprema e interrogatorio por el billete defectuoso.
40. `40_la_confesion_de_nanba`: Revelación del pasado de Nanba, búsqueda de su hermano periodista Shoichi, descarga con taser y captura como rehén.
41. `41_el_rescate_de_nanba`: Rescate inquebrantable de Nanba, combate de jefe contra Joon-gi Han, huida de Nanba y citación en Heian Tower a las 2 AM.
42. `42_la_cumbre_de_los_tres`: Hallazgo del portátil de Nanba con la trama política de Yutaka Ogikubo, reunión cumbre con Zhao, Seonhee y Hoshino en Heian Tower.

### Capítulo 8: Bleached Black (2019)
43. `43_el_pacto_de_los_tres`: Revelación histórica de posguerra, sistema de Ogikubo y sobornos policiales para sostener la zona gris de Ijincho.
44. `44_el_dilema_de_la_lealtad`: Ultimátum mafioso para silenciar a Nanba, rotunda negativa de Kasuga y pista al Edificio Hakuryo.
45. `45_asalto_al_edificio_hakuryo`: Perímetro de Bleach Japan en Carriage Highway, combate contra el asesino de Matsuo e ingreso a la planta 2F.
46. `46_la_caida_de_mabuchi`: Reencuentro en el despacho con Nanba y Ogasawara, combate definitivo de jefe contra Akira Mabuchi y confesión sobre el crimen de Nonomiya y la Omi.
47. `47_la_huida_de_nanba`: Partida de Nanba cargando a Mabuchi para rescatar a su hermano Shoichi y hallazgo de la foto fundacional de Bleach Japan.
48. `48_la_verdadera_identidad_de_aoki`: Revelación de que el gobernador Ryo Aoki es Masato Arakawa, orden de Aoki a la Alianza Omi para invadir Yokohama y transición al Capítulo 9.

### Capítulo 9: House of Cards (2019)
49. `49_el_perfil_de_aoki`: Estudio del perfil público de Aoki en Survive Bar, deducción del Plan 3K, cirugía motriz y cuartel en la segunda planta.
50. `50_el_contraataque_de_totsuka`: Auxilio a Hamako frente a disidentes del Seiryu, derrota de Totsuka y protección del albergue.
51. `51_la_marcha_de_los_mil`: Llamada de Zhao, marcha masiva de Bleach Japan/Omi hacia Geomijul, contención de matones y desengaño de Kume.
52. `52_la_bola_de_demolicion`: Asalto de Reiji Ishioda a los mandos de la grúa demoledora, batalla mecánica de jefe y brecha perimetral.
53. `53_el_voto_de_eomeoni`: Contacto con Joon-gi Han, pasadizo secreto en Eomeoni's Vow, reverencia de Seonhee y orden de tierra quemada de Ogikubo.
54. `54_el_sacrificio_de_geomijul`: Batalla campal en la imprenta en llamas contra Ishioda y Nanba, captura de Ogasawara, supervivencia confirmada de Shoichi y transición al Capítulo 10.

### Capítulo 10: Justice Bracket (2019)
55. `55_el_interrogatorio_de_ogasawara`: Interrogatorio en el campamento, alerta de golpe de Estado de Mabuchi y despedida temporal de Nanba tras confirmar la seguridad de Shoichi.
56. `56_el_rescate_de_zhao`: Incorporación de Joon-gi Han como refuerzo, enfrentamiento en Restaurant Row con Zheng (recompensa de ¥100M) e infiltración a Qing Jin.
57. `57_el_dragon_y_el_tigre`: Batalla contra los tigres en el cuartel de Qing Jin, encuentro con Yosuke Tendo e Ishioda, y caída definitiva de Akira Mabuchi.
58. `58_el_retorno_de_nanba`: Duelo a muerte contra Reiji Ishioda, heroico retorno de Nanba al combate, apretón de manos de reconciliación y reporte de recuperación de Shoichi.
59. `59_reencuentro_con_mitsuo`: Liberación de Zhao, reencuentro privado con Mitsuo Yasuda (información sobre la familia Arakawa) y traspaso de la jefatura de los Liumang de Zhao a Seonhee.
60. `60_la_promesa_del_pato_de_pekin`: El Jefe del campamento confiesa el protocolo secreto de rescate médico; almuerzo de pato de Pekín con Hoshino en Heian Tower; revelación del asesinato de Toshio Arakawa en 1977 y el mensaje del billete defectuoso de 1984 («Ni la justicia ni la piedad deben desbalancear la balanza»); transición al Capítulo 11.

### Capítulo 11: The Odds (2019)
61. `61_el_ascenso_de_aoki`: Panorama político tras la caída de Ogikubo, integración de Zhao y Han en Survive Bar y mártir fabricado con Ogasawara.
62. `62_el_refugio_de_hamako`: Hamako cierra Harbor Light ante los albergues de Bleach Japan en Hamakita Park y pista del funeral de Ogasawara.
63. `63_el_funeral_de_ogasawara`: Panegírico con lágrimas de cocodrilo de Aoki respaldando a Sota Kume y deducción de la ruta subterránea ribereña.
64. `64_el_estacionamiento_subterraneo`: Descenso por el montacargas secreto, desenmascaramiento de los escoltas de la Omi y cita a solas pactada en Otohime Land.
65. `65_la_noche_en_otohime_land`: Encuentro privado con Aoki: el trasplante pulmonar, la verdad del crimen de Suzumori en el 2000 y el engaño de la revitalización.
66. `66_el_desengano_y_la_resolucion`: Huida con auxilio de Nanba, victoria sobre la Omi, llanto de Hamako por las deportaciones y pacto de guerra total sin retorno; transición al Capítulo 12.

### Capítulo 12: The End of the Yakuza (2019)
67. `67_el_despacho_del_gobernador`: Aoki cuestiona la cumbre de Watase y Arakawa, sospechas de traición y envío de Tendo a vigilar Osaka.
68. `68_rumbo_a_sotenbori`: Viaje a Osaka, llamada de Mitsuo en Cabaret Grand sobre la Cámara del Dragón y plan de catering.
69. `69_los_dragones_legendarios`: Infiltración al cuartel Omi, combate de prueba contra Goro Majima y Taiga Saejima, e intervención de Daigo y Arakawa.
70. `70_el_pacto_de_disolucion`: Revelación del Plan 3K, liberación de Masaru Watase y proclamación solemne de la disolución del Tojo y la Omi.
71. `71_la_gran_batalla_de_la_omi`: Batalla campal contra rebeldes Omi, intercepción providencial de Kazuma Kiryu y entrega del acta a la policía.
72. `72_la_noche_en_hamakita_y_el_golpe`: Encuentro nocturno con Masumi Arakawa en Hamakita Park, confidencias paternas y trágico hallazgo de su cadáver al día siguiente; transición al Capítulo 13.

### Capítulo 13: Coin Locker Baby (2019)
73. `73_el_dolor_en_el_muelle`: Desgarrador intento de Kasuga por alcanzar el cadáver de Arakawa en el muelle, reporte de Takabe y tensión en Kamurocho.
74. `74_el_lamento_y_la_determinacion`: Encuentro en Heian Tower con Hoshino, recuerdos del pato de Pekín de Arakawa y rechazo a la venganza militar mafiosa.
75. `75_la_candidatura_inesperada`: Enfrentamiento en Isezaki Road, fianza electoral de 3M y registro contrarreloj de Kasuga como candidato al parlamento.
76. `76_el_debate_en_hamakita`: Guerra de carteles, furgoneta de campaña y discurso sobre las zonas grises en Hamakita Park que humilla a Kume y enfurece a Aoki.
77. `77_el_apreton_de_manos_en_jinnai`: Aproximación a pie a la estación de Jinnai, apretón de manos público forzado a Kume y alerta roja por asalto a la sede del Seiryu.
78. `78_los_bebes_de_las_taquillas`: Incursión en la sede del Seiryu, muerte de Hoshino a manos de Sawashiro, duelo a muerte y revelación del linaje de los bebés de las taquillas; transición al Capítulo 14.

### Capítulo 14: Passing the Torch (2019)
79. `79_la_sangre_del_patriarca`: Asimilación de la verdad biológica en Survive Bar, rechazo a la venganza ciega, ruptura del asedio Omi y marcha hacia Hakuryo.
80. `80_la_aparicion_del_dragon`: Hakuryo desalojado, refriega callejera y detención de la furia de Kasuga por Kazuma Kiryu, quien lo cita en Geomijul.
81. `81_el_hilo_de_la_conspiracion`: Extorsión de Aoki a Horinouchi inculpando a Sawashiro y pacto telefónico con Ishioda para purgar Ijincho.
82. `82_la_prueba_del_dragon`: Juicio marcial contra Kiryu en el patio de Geomijul, visión del dragón plateado y conquista de la serenidad heroica.
83. `83_el_asesino_del_espejo`: Cámaras de seguridad en Geomijul, Zhao identifica a Mirror Face, despedida de Kiryu y ubicación de Ishioda en Bar District.
84. `84_fuego_cruzado_en_el_distrito_de_bares`: Asalto al escondite de Ishioda, trampa de Mirror Face desbaratada con preguntas de tránsito, combate dual, revelación de Tendo como autor del disparo a Arakawa y huida de la bomba; transición al Capítulo 15.

### Capítulo 15: To the Pinnacle (2019)
85. `85_el_farol_en_kamurocho`: Infiltración disfrazado ante la furgoneta de Aoki, apretón de manos público forzado, farol de la grabación en Millennium Tower y refugio en New Serena con Date.
86. `86_la_cumbre_de_la_torre_milenio`: Asalto a Millennium Tower bajo noticias del triunfo electoral de Kume, streaming táctico de Nick Ogata y brutal combate de boxeo noqueando a Yosuke Tendo.
87. `87_la_trampa_del_camaleon`: Interrupción del mitin del CLP con orden de arresto y desvelo de Masato Arakawa, huida de Aoki al ático, orden de ejecución ante el falso Tendo (Mirror Face) y transmisión viral en directo.
88. `88_el_fin_del_advenedizo`: Doblegamiento de los escoltas armados de Aoki, choque ideológico y personal puño a puño entre hermanos, toma de rehén con cristal roto y escape de Aoki por el ascensor.
89. `89_las_taquillas_del_destino`: Deambular de Aoki bajo sus propias pantallas de condena, suicidio frustrado ante las taquillas de 1977, llanto fraternal de Kasuga, rendición de Aoki y trágica puñalada de Sota Kume.
90. `90_hacia_la_cima`: Adachi entrega el pendrive del soborno arrestando a Horinouchi, funeral conjunto de Masumi y Masato Arakawa, rechazo a la oferta de Osaka y regreso triunfal del héroe protegiendo a la gente de Ijincho. Gran Final de la campaña.

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
  LABORATORIO NARRATIVO — YAKUZA: LIKE A DRAGON (CAPÍTULOS 1 AL 12)
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
3. Verás el **Dashboard de los Capítulos 1 al 12** con la estética urbana inspirada en Kamurocho y Yokohama.

### 3. Funcionalidades del Dashboard

- **Catálogo lateral por capítulos:** Selecciona cualquiera de los setenta y dos episodios (`01` a `72`) para ver su sinopsis y contexto.
- **Botón `▶ Ejecutar Episodio`:** Ejecuta el escenario seleccionado de forma determinista y despliega:
  - **Estado Final del Mundo:** Ubicación exacta, periodo temporal, saldo en yenes (¥), inventario de ítems y banderas booleanas activas.
  - **Línea de Timeline de Eventos:** Cronología secuencial de todos los eventos emitidos con actor, objetivo, escena y datos del payload.
- **Documentación Técnica Integrada:** Accede directamente a las 5 secciones de documentación de cada episodio (`Briefing`, `Escenas`, `Mecánicas`, `Lab` y `AAR`) renderizadas con formato enriquecido.

---

## Uso de la CLI

El runner de línea de comandos se encuentra en `bin/episodio`:

```bash
# Ejecutar cualquier episodio por su identificador (01 a 72)
ruby -Ilib bin/episodio 01
ruby -Ilib bin/episodio 08
ruby -Ilib bin/episodio 14
ruby -Ilib bin/episodio 19
ruby -Ilib bin/episodio 25
ruby -Ilib bin/episodio 31
ruby -Ilib bin/episodio 37
ruby -Ilib bin/episodio 43
ruby -Ilib bin/episodio 49
ruby -Ilib bin/episodio 55
ruby -Ilib bin/episodio 61
ruby -Ilib bin/episodio 67
ruby -Ilib bin/episodio 72

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
# Ejecutar todas las pruebas (337 tests, 2127 aserciones, 0 fallos)
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
ruby -Ilib -Itest test/test_chapter4_continuity.rb
ruby -Ilib -Itest test/test_chapter5_continuity.rb
ruby -Ilib -Itest test/test_chapter6_continuity.rb
ruby -Ilib -Itest test/test_chapter7_continuity.rb
ruby -Ilib -Itest test/test_chapter8_continuity.rb
ruby -Ilib -Itest test/test_chapter9_continuity.rb
ruby -Ilib -Itest test/test_chapter10_continuity.rb
ruby -Ilib -Itest test/test_chapter11_continuity.rb
ruby -Ilib -Itest test/test_chapter12_continuity.rb
ruby -Ilib -Itest test/test_chapter13_continuity.rb
ruby -Ilib -Itest test/test_chapter14_continuity.rb
ruby -Ilib -Itest test/test_chapter15_continuity.rb
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
│   ├── episodio                       # Runner CLI ejecutable (01 a 90)
│   └── servidor                       # Servidor web Sinatra ejecutable (puerto 4567)
├── docs/
│   └── episodios/                     # 450 documentos (ep01 a ep90: briefing, escenas, mecánicas, lab, aar)
├── lib/
│   ├── ichiban_lab.rb                 # Punto de entrada de la gema / librería
│   └── ichiban_lab/                   # Dominio (Character, WorldState, EventLog, Scene, Scenarios, WebApp)
├── prompts/                           # Plantillas y control de estado (ESTADO.txt)
└── test/                              # Suite de pruebas Minitest (337 tests, 2127 aserciones)
```
