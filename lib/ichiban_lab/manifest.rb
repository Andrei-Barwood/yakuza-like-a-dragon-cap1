# frozen_string_literal: true

module IchibanLab
  module Manifest
    EpisodeInfo = Struct.new(:id, :slug, :title, :class_name, :description, keyword_init: true)

    EPISODES = [
      EpisodeInfo.new(
        id: "01",
        slug: "01_origen",
        title: "La primera deuda",
        class_name: "IchibanLab::Scenarios::Ep01",
        description: "Prólogo de Masumi niño: el vínculo con Toshio y la muerte de su padre."
      ),
      EpisodeInfo.new(
        id: "02",
        slug: "02_cobranza",
        title: "El trabajo del día",
        class_name: "IchibanLab::Scenarios::Ep02",
        description: "Ichiban adulto y Mitsuo: cobranza a Ushio y devolución a los compradores."
      ),
      EpisodeInfo.new(
        id: "03",
        slug: "03_encargo_urgente",
        title: "Un favor en el barrio",
        class_name: "IchibanLab::Scenarios::Ep03",
        description: "Recado de Michiyo, desatascador de Shangri-La y protección al anciano."
      ),
      EpisodeInfo.new(
        id: "04",
        slug: "04_lo_que_se_debe",
        title: "Cobrar sin destruir",
        class_name: "IchibanLab::Scenarios::Ep04",
        description: "Deuda de Hiratsuka en Public Park 3 y decisión de cuánto dinero cobrar."
      ),
      EpisodeInfo.new(
        id: "05",
        slug: "05_el_joven_maestro",
        title: "Una noche para Masato",
        class_name: "IchibanLab::Scenarios::Ep05",
        description: "Acompañar a Masato al club, buscar a Yumeno y escuchar la verdad."
      ),
      EpisodeInfo.new(
        id: "06",
        slug: "06_lo_que_nos_une",
        title: "La familia Arakawa",
        class_name: "IchibanLab::Scenarios::Ep06",
        description: "Regreso a la oficina, cena compartida con Arakawa y altercado en Theater Square."
      ),
      EpisodeInfo.new(
        id: "07",
        slug: "07_el_precio",
        title: "Quince años",
        class_name: "IchibanLab::Scenarios::Ep07",
        description: "Ataque de los Sakaki, la petición de Arakawa y la entrega a la policía."
      )
    ].freeze

    def self.all
      EPISODES
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
