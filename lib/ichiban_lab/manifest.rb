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
