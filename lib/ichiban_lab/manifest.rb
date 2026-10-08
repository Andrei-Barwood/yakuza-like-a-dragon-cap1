# frozen_string_literal: true

module IchibanLab
  module Manifest
    EpisodeInfo = Struct.new(:id, :slug, :title, :class_name, :description, :chapter, keyword_init: true)

    EPISODES = [
      # --- CAPÍTULO 1: LIGHT AND SHADOW ---
      EpisodeInfo.new(
        id: "01",
        slug: "01_origen",
        title: "La primera deuda",
        class_name: "IchibanLab::Scenarios::Ep01",
        description: "Prólogo de Masumi niño: el vínculo con Toshio y la muerte de su padre.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "02",
        slug: "02_cobranza",
        title: "El trabajo del día",
        class_name: "IchibanLab::Scenarios::Ep02",
        description: "Ichiban adulto y Mitsuo: cobranza a Ushio y devolución a los compradores.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "03",
        slug: "03_encargo_urgente",
        title: "Un favor en el barrio",
        class_name: "IchibanLab::Scenarios::Ep03",
        description: "Recado de Michiyo, desatascador de Shangri-La y protección al anciano.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "04",
        slug: "04_lo_que_se_debe",
        title: "Cobrar sin destruir",
        class_name: "IchibanLab::Scenarios::Ep04",
        description: "Deuda de Hiratsuka en Public Park 3 y decisión de cuánto dinero cobrar.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "05",
        slug: "05_el_joven_maestro",
        title: "Una noche para Masato",
        class_name: "IchibanLab::Scenarios::Ep05",
        description: "Acompañar a Masato al club, buscar a Yumeno y escuchar la verdad.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "06",
        slug: "06_lo_que_nos_une",
        title: "La familia Arakawa",
        class_name: "IchibanLab::Scenarios::Ep06",
        description: "Regreso a la oficina, cena compartida con Arakawa y altercado en Theater Square.",
        chapter: 1
      ),
      EpisodeInfo.new(
        id: "07",
        slug: "07_el_precio",
        title: "Quince años",
        class_name: "IchibanLab::Scenarios::Ep07",
        description: "Ataque de los Sakaki, la petición de Arakawa y la entrega a la policía.",
        chapter: 1
      ),

      # --- CAPÍTULO 2: BLOODY REUNION ---
      EpisodeInfo.new(
        id: "08",
        slug: "08_liberacion",
        title: "18 años después",
        class_name: "IchibanLab::Scenarios::Ep08",
        description: "Salida de prisión en 2019, soledad y abordaje del ex-detective Adachi.",
        chapter: 2
      ),
      EpisodeInfo.new(
        id: "09",
        slug: "09_el_nuevo_kamurocho",
        title: "El nuevo Kamurocho",
        class_name: "IchibanLab::Scenarios::Ep09",
        description: "Retorno al barrio transformado y descubrimiento de la ocupación de la Alianza Omi.",
        chapter: 2
      ),
      EpisodeInfo.new(
        id: "10",
        slug: "10_rescate_en_la_calle",
        title: "Alianza con Adachi y Nick Ogata",
        class_name: "IchibanLab::Scenarios::Ep10",
        description: "Rescate de Nick Ogata frente a extorsionadores y unión formal de Adachi al grupo.",
        chapter: 2
      ),
      EpisodeInfo.new(
        id: "11",
        slug: "11_los_bajos_fondos",
        title: "Los conductos subterráneos",
        class_name: "IchibanLab::Scenarios::Ep11",
        description: "Infiltración a través de las alcantarillas subterráneas para evitar el cerco policial.",
        chapter: 2
      ),
      EpisodeInfo.new(
        id: "12",
        slug: "12_el_guantelete",
        title: "Duelo con Sawashiro",
        class_name: "IchibanLab::Scenarios::Ep12",
        description: "Asalto a la reunión cumbre de la Omi y combate contra el capitán Jo Sawashiro.",
        chapter: 2
      ),
      EpisodeInfo.new(
        id: "13",
        slug: "13_reunion_sangrienta",
        title: "Reunión sangrienta",
        class_name: "IchibanLab::Scenarios::Ep13",
        description: "Cara a cara con Masumi Arakawa, el disparo a quemarropa y el rescate de Nanba en Yokohama.",
        chapter: 2
      ),

      # --- CAPÍTULO 3: THE TOWN AT ROCK BOTTOM ---
      EpisodeInfo.new(
        id: "14",
        slug: "14_la_ciudad_en_el_fondo",
        title: "La ciudad en el fondo",
        class_name: "IchibanLab::Scenarios::Ep14",
        description: "Despertar en Isezaki Ijincho junto a Nanba, aprendizaje de supervivencia y permiso del Jefe del campamento.",
        chapter: 3
      ),
      EpisodeInfo.new(
        id: "15",
        slug: "15_la_ley_del_campamento",
        title: "La ley del campamento",
        class_name: "IchibanLab::Scenarios::Ep15",
        description: "Recolección de latas, extorsión de Zheng (Yokohama Liumang) y descubrimiento del billete falso en el bolsillo.",
        chapter: 3
      ),
      EpisodeInfo.new(
        id: "16",
        slug: "16_en_busca_de_empleo",
        title: "En busca de empleo",
        class_name: "IchibanLab::Scenarios::Ep16",
        description: "Visita a Hello Work, entrevista con Ririka y encargo especial del Director Kanbe para The Harbor Light.",
        chapter: 3
      ),
      EpisodeInfo.new(
        id: "17",
        slug: "17_defensa_de_harbor_light",
        title: "Defensa de The Harbor Light",
        class_name: "IchibanLab::Scenarios::Ep17",
        description: "Guardia en el bar de Hamako, enfrentamiento contra Matsuo y desafío abierto al francotirador de Geomijul.",
        chapter: 3
      ),
      EpisodeInfo.new(
        id: "18",
        slug: "18_un_techo_y_un_ideal",
        title: "Un techo y un ideal",
        class_name: "IchibanLab::Scenarios::Ep18",
        description: "Enfrentamiento a Bleach Japan y Sota Kume, habitación propia en el hostal de Hamako y el sueño de convertirse en Héroe.",
        chapter: 3
      ),

      # --- CAPÍTULO 4: THE DRAGON OF YOKOHAMA ---
      EpisodeInfo.new(
        id: "19",
        slug: "19_el_empleo_prometido",
        title: "El empleo prometido",
        class_name: "IchibanLab::Scenarios::Ep19",
        description: "Regreso a Hello Work con domicilio legal, reencuentro con Adachi y oferta de Nonomiya en Otohime Land.",
        chapter: 4
      ),
      EpisodeInfo.new(
        id: "20",
        slug: "20_otohime_land",
        title: "La sospecha de Nonomiya",
        class_name: "IchibanLab::Scenarios::Ep20",
        description: "Llegada al soapland Otohime Land, encargo de investigar a Nanoha Mukoda y vigilancia en Pocket Café.",
        chapter: 4
      ),
      EpisodeInfo.new(
        id: "21",
        slug: "21_el_castillo_de_la_luz",
        title: "Infiltración en Sunlight Castle",
        class_name: "IchibanLab::Scenarios::Ep21",
        description: "Colocación como contratistas con Kanbe en el asilo y descubrimiento del fraude de pensiones y eutanasia.",
        chapter: 4
      ),
      EpisodeInfo.new(
        id: "22",
        slug: "22_la_noche_en_survive",
        title: "La noche en Survive Bar",
        class_name: "IchibanLab::Scenarios::Ep22",
        description: "Refugio y reunión en Survive Bar junto a Adachi y Nanba: plazo de diez días para salvar a Tatsuro Mukoda.",
        chapter: 4
      ),
      EpisodeInfo.new(
        id: "23",
        slug: "23_el_rescate_de_tatsuro",
        title: "El rescate en la sala VIP",
        class_name: "IchibanLab::Scenarios::Ep23",
        description: "Asalto a la Excellent Room de Sunlight Castle, freno a la inyección letal de cloruro de potasio y caída de Totsuka.",
        chapter: 4
      ),
      EpisodeInfo.new(
        id: "24",
        slug: "24_el_dragon_del_seiryu",
        title: "La sede del Seiryu y el precio del silencio",
        class_name: "IchibanLab::Scenarios::Ep24",
        description: "Audiencia con Ryuhei Hoshino del Clan Seiryu, restitución de fondos a Nanoha y hallazgo del cuerpo de Nonomiya.",
        chapter: 4
      ),

      # --- CAPÍTULO 5: THE LIUMANG'S WEB ---
      EpisodeInfo.new(
        id: "25",
        slug: "25_la_heredera_de_otohime",
        title: "La heredera de Otohime Land",
        class_name: "IchibanLab::Scenarios::Ep25",
        description: "Muerte de Nonomiya, alianza con Saeko Mukoda y sospechas hacia Akira Mabuchi de Yokohama Liumang.",
        chapter: 5
      ),
      EpisodeInfo.new(
        id: "26",
        slug: "26_el_club_lin_lin",
        title: "El club Lin Lin y la pista de Mabuchi",
        class_name: "IchibanLab::Scenarios::Ep26",
        description: "Incursión en Lin Lin Hostess Bar, derrota de Zheng y descubrimiento de Yokohama Trading Company.",
        chapter: 5
      ),
      EpisodeInfo.new(
        id: "27",
        slug: "27_el_cambio_de_oficio",
        title: "El cambio de oficio y el empleo encubierto",
        class_name: "IchibanLab::Scenarios::Ep27",
        description: "Desbloqueo del Job System con Ririka en Hello Work e infiltración como mozos de almacén en el muelle de Hamakita.",
        chapter: 5
      ),
      EpisodeInfo.new(
        id: "28",
        slug: "28_la_resistencia_vecinal",
        title: "La resistencia de Otohime Land",
        class_name: "IchibanLab::Scenarios::Ep28",
        description: "Manifestación hostil de Bleach Japan frente al soapland, confrontación con Sota Kume y apoyo de la comunidad.",
        chapter: 5
      ),
      EpisodeInfo.new(
        id: "29",
        slug: "29_la_imprenta_clandestina",
        title: "La imprenta clandestina",
        class_name: "IchibanLab::Scenarios::Ep29",
        description: "Investigación en el almacén de Mabuchi, sospecha de falsificación de yuanes y plan para obtener una muestra del papel.",
        chapter: 5
      ),
      EpisodeInfo.new(
        id: "30",
        slug: "30_explosion_en_el_muelle",
        title: "Explosión en el muelle de Hamakita",
        class_name: "IchibanLab::Scenarios::Ep30",
        description: "Detección de la trampa por los capataces de Liumang, choque del camión cisterna, explosión del almacén y desenlace del Capítulo 5.",
        chapter: 5
      ),

      # --- CAPÍTULO 6: IGNITION ---
      EpisodeInfo.new(
        id: "31",
        slug: "31_el_despertar_encadenado",
        title: "El despertar encadenado",
        class_name: "IchibanLab::Scenarios::Ep31",
        description: "Cautiverio en el sótano secreto de Mabuchi, interrogatorio grabado para culpar al Seiryu y admisión del asesinato de Nonomiya.",
        chapter: 6
      ),
      EpisodeInfo.new(
        id: "32",
        slug: "32_la_fuga_subterranea",
        title: "La fuga subterránea",
        class_name: "IchibanLab::Scenarios::Ep32",
        description: "Intervención de un salvador anónimo, liberación de los compañeros, recuperación del botín y aislamiento sin cobertura.",
        chapter: 6
      ),
      EpisodeInfo.new(
        id: "33",
        slug: "33_el_duelo_de_la_excavadora",
        title: "El duelo de la excavadora",
        class_name: "IchibanLab::Scenarios::Ep33",
        description: "Ascenso por los conductos de contrabando hacia B1F, batalla de jefe contra la excavadora pesada de Yan y salida a la superficie.",
        chapter: 6
      ),
      EpisodeInfo.new(
        id: "34",
        slug: "34_la_chispa_del_conflicto",
        title: "La chispa del conflicto",
        class_name: "IchibanLab::Scenarios::Ep34",
        description: "Llamada urgente al Patriarca Hoshino, noticias de asesinatos en Isezaki Road, represalia de Takabe y deducción de la trampa de Mabuchi.",
        chapter: 6
      ),
      EpisodeInfo.new(
        id: "35",
        slug: "35_camino_a_restaurant_row",
        title: "Camino a Restaurant Row",
        class_name: "IchibanLab::Scenarios::Ep35",
        description: "Incursión entre las víctimas de la guerra de pandillas, disparo a los pies frente a Qing Jin y combate a puño limpio con Takabe.",
        chapter: 6
      ),
      EpisodeInfo.new(
        id: "36",
        slug: "36_el_juicio_de_tianyou_zhao",
        title: "El juicio de Tianyou Zhao",
        class_name: "IchibanLab::Scenarios::Ep36",
        description: "Llegada del líder de Yokohama Liumang, exhibición del video editado, tregua armada y orden de buscar pruebas en Geomijul.",
        chapter: 6
      ),

      # --- CAPÍTULO 7: THE SPIDER'S WEB ---
      EpisodeInfo.new(
        id: "37",
        slug: "37_el_barrio_coreano",
        title: "El barrio coreano y la guía enigmática",
        class_name: "IchibanLab::Scenarios::Ep37",
        description: "Búsqueda de Geomijul en Koreatown, encuentro con la mujer misteriosa y llegada a la fachada de cables eléctricos.",
        chapter: 7
      ),
      EpisodeInfo.new(
        id: "38",
        slug: "38_la_fortaleza_electrica",
        title: "La fortaleza eléctrica",
        class_name: "IchibanLab::Scenarios::Ep38",
        description: "Traspaso de puentes de alta tensión, reencuentro con Joon-gi Han y confirmación de la cinta de seguridad de Mabuchi en Otohime Land.",
        chapter: 7
      ),
      EpisodeInfo.new(
        id: "39",
        slug: "39_la_reina_de_la_telaraña",
        title: "La reina de la telaraña",
        class_name: "IchibanLab::Scenarios::Ep39",
        description: "Descubrimiento de la imprenta clandestina de yenes, aparición de Seonhee como líder de Geomijul e interrogatorio por el billete defectuoso.",
        chapter: 7
      ),
      EpisodeInfo.new(
        id: "40",
        slug: "40_la_confesion_de_nanba",
        title: "La confesión de Nanba",
        class_name: "IchibanLab::Scenarios::Ep40",
        description: "Revelación del pasado de Nanba, la búsqueda de su hermano periodista Shoichi, electrocución con taser y captura como rehén.",
        chapter: 7
      ),
      EpisodeInfo.new(
        id: "41",
        slug: "41_el_rescate_de_nanba",
        title: "El rescate de Nanba",
        class_name: "IchibanLab::Scenarios::Ep41",
        description: "Defensa inquebrantable de Nanba por Kasuga, victoria en combate contra Joon-gi Han, huida de Nanba y citación en Heian Tower a las 2 AM.",
        chapter: 7
      ),
      EpisodeInfo.new(
        id: "42",
        slug: "42_la_cumbre_de_los_tres",
        title: "La cumbre de los Tres de Ijin",
        class_name: "IchibanLab::Scenarios::Ep42",
        description: "Investigación en el ordenador de Nanba sobre Yutaka Ogikubo, ascenso a Heian Tower y reunión cumbre de los tres líderes de Ijincho.",
        chapter: 7
      ),

      # --- CAPÍTULO 8: BLEACHED BLACK ---
      EpisodeInfo.new(
        id: "43",
        slug: "43_el_pacto_de_los_tres",
        title: "El pacto de los tres",
        class_name: "IchibanLab::Scenarios::Ep43",
        description: "Audiencia en Heian Tower, la historia de posguerra, la propuesta de Ogikubo y el origen de la zona gris de Ijincho.",
        chapter: 8
      ),
      EpisodeInfo.new(
        id: "44",
        slug: "44_el_dilema_de_la_lealtad",
        title: "El dilema de la lealtad",
        class_name: "IchibanLab::Scenarios::Ep44",
        description: "Exigencia de silenciar a Nanba, negativa absoluta de Ichiban a traicionar a su amigo y pista hacia el Edificio Hakuryo.",
        chapter: 8
      ),
      EpisodeInfo.new(
        id: "45",
        slug: "45_asalto_al_edificio_hakuryo",
        title: "Asalto al edificio Hakuryo",
        class_name: "IchibanLab::Scenarios::Ep45",
        description: "Llegada a la sede de Bleach Japan, emboscada del renegado de Geomijul y asalto a la segunda planta.",
        chapter: 8
      ),
      EpisodeInfo.new(
        id: "46",
        slug: "46_la_caida_de_mabuchi",
        title: "La caída de Mabuchi",
        class_name: "IchibanLab::Scenarios::Ep46",
        description: "Reencuentro con Nanba, batalla definitiva contra Akira Mabuchi y confesión de la alianza de Ogasawara con la Omi Alliance.",
        chapter: 8
      ),
      EpisodeInfo.new(
        id: "47",
        slug: "47_la_huida_de_nanba",
        title: "La huida de Nanba",
        class_name: "IchibanLab::Scenarios::Ep47",
        description: "Nanba se lleva a Mabuchi para dar con su hermano, registro de la oficina y hallazgo de la foto fundacional de Bleach Japan.",
        chapter: 8
      ),
      EpisodeInfo.new(
        id: "48",
        slug: "48_la_verdadera_identidad_de_aoki",
        title: "La verdadera identidad de Aoki",
        class_name: "IchibanLab::Scenarios::Ep48",
        description: "Descubrimiento de que Ryo Aoki es Masato Arakawa, despacho de Tokio y orden de movilización de tropas de la Omi hacia Yokohama.",
        chapter: 8
      ),
      # --- CAPÍTULO 9: HOUSE OF CARDS ---
      EpisodeInfo.new(
        id: "49",
        slug: "49_el_perfil_de_aoki",
        title: "El perfil de Aoki",
        class_name: "IchibanLab::Scenarios::Ep49",
        description: "Análisis del historial de Aoki en Survive Bar, deducción del Plan 3K, cirugía motriz y cuartel en la segunda planta.",
        chapter: 9
      ),
      EpisodeInfo.new(
        id: "50",
        slug: "50_el_contraataque_de_totsuka",
        title: "El contraataque de Totsuka",
        class_name: "IchibanLab::Scenarios::Ep50",
        description: "Llamada de Hamako, fractura en el Clan Seiryu por el dinero falso, derrota de Totsuka y salvaguarda de Hamako.",
        chapter: 9
      ),
      EpisodeInfo.new(
        id: "51",
        slug: "51_la_marcha_de_los_mil",
        title: "La marcha de los mil",
        class_name: "IchibanLab::Scenarios::Ep51",
        description: "Llamada de Zhao, marcha masiva de Bleach Japan/Omi hacia Geomijul, derrota de matones y confesión de Kume.",
        chapter: 9
      ),
      EpisodeInfo.new(
        id: "52",
        slug: "52_la_bola_de_demolicion",
        title: "La bola de demolición",
        class_name: "IchibanLab::Scenarios::Ep52",
        description: "Aparición de Reiji Ishioda con la grúa demoledora, batalla de jefe mecánica y destrucción de la barricada de Geomijul.",
        chapter: 9
      ),
      EpisodeInfo.new(
        id: "53",
        slug: "53_el_voto_de_eomeoni",
        title: "El voto de Eomeoni",
        class_name: "IchibanLab::Scenarios::Ep53",
        description: "Contacto con Joon-gi Han, pasaje secreto en Eomeoni's Vow, reverencia de Seonhee y pacto de tierra quemada para proteger a Ogikubo.",
        chapter: 9
      ),
      EpisodeInfo.new(
        id: "54",
        slug: "54_el_sacrificio_de_geomijul",
        title: "El sacrificio de Geomijul",
        class_name: "IchibanLab::Scenarios::Ep54",
        description: "Batalla campal en la imprenta en llamas contra Ishioda y Nanba, captura de Ogasawara y confirmación de que Shoichi sigue vivo.",
        chapter: 9
      ),
      # --- CAPÍTULO 10: JUSTICE BRACKET ---
      EpisodeInfo.new(
        id: "55",
        slug: "55_el_interrogatorio_de_ogasawara",
        title: "El interrogatorio de Ogasawara",
        class_name: "IchibanLab::Scenarios::Ep55",
        description: "Confesiones de Ogasawara en el campamento, alerta del golpe de Mabuchi y despedida temporal de Nanba.",
        chapter: 10
      ),
      EpisodeInfo.new(
        id: "56",
        slug: "56_el_rescate_de_zhao",
        title: "El rescate de Zhao",
        class_name: "IchibanLab::Scenarios::Ep56",
        description: "Incorporación de Joon-gi Han como refuerzo, emboscada de Zheng en Restaurant Row e infiltración en Qing Jin.",
        chapter: 10
      ),
      EpisodeInfo.new(
        id: "57",
        slug: "57_el_dragon_y_el_tigre",
        title: "El dragón y el tigre",
        class_name: "IchibanLab::Scenarios::Ep57",
        description: "Combate contra el tigre de Qing Jin, encuentro con Yosuke Tendo e Ishioda, y derrota definitiva de Akira Mabuchi.",
        chapter: 10
      ),
      EpisodeInfo.new(
        id: "58",
        slug: "58_el_retorno_de_nanba",
        title: "El retorno de Nanba",
        class_name: "IchibanLab::Scenarios::Ep58",
        description: "Duelo a muerte contra Reiji Ishioda, regreso providencial de Nanba, victoria y apretón de manos de reconciliación.",
        chapter: 10
      ),
      EpisodeInfo.new(
        id: "59",
        slug: "59_reencuentro_con_mitsuo",
        title: "Reencuentro con Mitsuo",
        class_name: "IchibanLab::Scenarios::Ep59",
        description: "Liberación de Zhao, encuentro privado con Mitsuo Yasuda, planes de Arakawa y sucesión de mando en Liumang hacia Seonhee.",
        chapter: 10
      ),
      EpisodeInfo.new(
        id: "60",
        slug: "60_la_promesa_del_pato_de_pekin",
        title: "La promesa del pato de Pekín",
        class_name: "IchibanLab::Scenarios::Ep60",
        description: "Pacto de Arakawa con los indigentes, almuerzo en Heian Tower con Hoshino, la muerte de Toshio y el billete defectuoso de 1984.",
        chapter: 10
      ),

      # --- CAPÍTULO 11: THE ODDS ---
      EpisodeInfo.new(
        id: "61",
        slug: "61_el_ascenso_de_aoki",
        title: "El ascenso de Aoki",
        class_name: "IchibanLab::Scenarios::Ep61",
        description: "Panorama político tras la caída de Ogikubo, bienvenida a Zhao y Han en Survive Bar y mártir fabricado con Ogasawara.",
        chapter: 11
      ),
      EpisodeInfo.new(
        id: "62",
        slug: "62_el_refugio_de_hamako",
        title: "El refugio de Hamako",
        class_name: "IchibanLab::Scenarios::Ep62",
        description: "Hamako cierra Harbor Light ante los albergues de Bleach Japan en Hamakita Park y pista del funeral de Ogasawara.",
        chapter: 11
      ),
      EpisodeInfo.new(
        id: "63",
        slug: "63_el_funeral_de_ogasawara",
        title: "El funeral de Ogasawara",
        class_name: "IchibanLab::Scenarios::Ep63",
        description: "Panegírico con lágrimas de cocodrilo de Aoki respaldando a Sota Kume y deducción de la ruta subterránea ribereña.",
        chapter: 11
      ),
      EpisodeInfo.new(
        id: "64",
        slug: "64_el_estacionamiento_subterraneo",
        title: "El estacionamiento subterráneo",
        class_name: "IchibanLab::Scenarios::Ep64",
        description: "Descenso por el montacargas secreto, desenmascaramiento de los escoltas de la Omi y cita a solas pactada en Otohime Land.",
        chapter: 11
      ),
      EpisodeInfo.new(
        id: "65",
        slug: "65_la_noche_en_otohime_land",
        title: "La noche en Otohime Land",
        class_name: "IchibanLab::Scenarios::Ep65",
        description: "Encuentro privado con Aoki: el trasplante pulmonar, la verdad del crimen de Suzumori en el 2000 y el engaño de la revitalización.",
        chapter: 11
      ),
      EpisodeInfo.new(
        id: "66",
        slug: "66_el_desengano_y_la_resolucion",
        title: "El desengaño y la resolución",
        class_name: "IchibanLab::Scenarios::Ep66",
        description: "Huida con auxilio de Nanba, victoria sobre la Omi, llanto de Hamako por las deportaciones y pacto de guerra total sin retorno.",
        chapter: 11
      ),

      # --- CAPÍTULO 12: THE END OF THE YAKUZA ---
      EpisodeInfo.new(
        id: "67",
        slug: "67_el_despacho_del_gobernador",
        title: "El despacho del gobernador",
        class_name: "IchibanLab::Scenarios::Ep67",
        description: "Aoki cuestiona la cumbre de Watase y Arakawa, sospechas de traición y envío de Tendo a vigilar Osaka.",
        chapter: 12
      ),
      EpisodeInfo.new(
        id: "68",
        slug: "68_rumbo_a_sotenbori",
        title: "Rumbo a Sotenbori",
        class_name: "IchibanLab::Scenarios::Ep68",
        description: "Viaje a Osaka, llamada de Mitsuo en Cabaret Grand sobre la Cámara del Dragón y plan de catering.",
        chapter: 12
      ),
      EpisodeInfo.new(
        id: "69",
        slug: "69_los_dragones_legendarios",
        title: "Los dragones legendarios",
        class_name: "IchibanLab::Scenarios::Ep69",
        description: "Infiltración al cuartel Omi, combate de prueba contra Goro Majima y Taiga Saejima, e intervención de Daigo y Arakawa.",
        chapter: 12
      ),
      EpisodeInfo.new(
        id: "70",
        slug: "70_el_pacto_de_disolucion",
        title: "El pacto de disolución",
        class_name: "IchibanLab::Scenarios::Ep70",
        description: "Revelación del Plan 3K, liberación de Masaru Watase y proclamación solemne de la disolución del Tojo y la Omi.",
        chapter: 12
      ),
      EpisodeInfo.new(
        id: "71",
        slug: "71_la_gran_batalla_de_la_omi",
        title: "La gran batalla de la Omi",
        class_name: "IchibanLab::Scenarios::Ep71",
        description: "Batalla campal contra rebeldes Omi, intercepción providencial de Kazuma Kiryu y entrega del acta a la policía.",
        chapter: 12
      ),
      EpisodeInfo.new(
        id: "72",
        slug: "72_la_noche_en_hamakita_y_el_golpe",
        title: "La noche en Hamakita y el golpe",
        class_name: "IchibanLab::Scenarios::Ep72",
        description: "Encuentro nocturno con Masumi Arakawa en Hamakita Park, confidencias paternas y trágico hallazgo de su cadáver al día siguiente.",
        chapter: 12
      )
    ].freeze

    def self.all
      EPISODES
    end

    def self.by_chapter(num)
      EPISODES.select { |ep| ep.chapter == num.to_i }
    end

    def self.ids
      EPISODES.map(&:id)
    end

    def self.valid_id?(id)
      normalized = normalize_id(id)
      ids.include?(normalized)
    end

    def self.find(id_or_slug)
      return nil if id_or_slug.nil?
      norm = normalize_id(id_or_slug)
      EPISODES.find { |ep| ep.id == norm || ep.slug == id_or_slug.to_s }
    end

    def self.normalize_id(raw)
      s = raw.to_s.strip
      if s =~ /^\d$/
        sprintf("%02d", s.to_i)
      else
        s
      end
    end
  end
end
