# frozen_string_literal: true

module IchibanLab
  class Character
    attr_reader :id, :name, :attributes, :relationships, :belongings

    def initialize(id:, name:, attributes: {}, relationships: {}, belongings: [])
      raise ArgumentError, "Character id is required" if id.nil? || id.to_s.strip.empty?
      raise ArgumentError, "Character name is required" if name.nil? || name.to_s.strip.empty?

      @id = id.to_sym
      @name = name.to_s.freeze
      @attributes = attributes.dup
      @relationships = relationships.dup
      @belongings = belongings.dup
    end

    def attribute(key, default = nil)
      @attributes.fetch(key.to_sym, default)
    end

    def set_attribute(key, value)
      @attributes[key.to_sym] = value
    end

    def relationship(target_id)
      @relationships[target_id.to_sym]
    end

    def set_relationship(target_id, relation_type)
      @relationships[target_id.to_sym] = relation_type
    end

    def has_belonging?(item)
      @belongings.include?(item)
    end

    def add_belonging(item)
      @belongings << item unless has_belonging?(item)
      @belongings
    end

    def remove_belonging(item)
      @belongings.delete(item)
    end

    def deep_clone
      Character.new(
        id: @id,
        name: @name,
        attributes: @attributes.dup,
        relationships: @relationships.dup,
        belongings: @belongings.dup
      )
    end
  end
end
