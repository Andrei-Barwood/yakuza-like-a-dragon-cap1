# frozen_string_literal: true

module IchibanLab
  class WorldState
    attr_accessor :episode, :scene_id, :location, :time_period, :money
    attr_reader :characters, :inventory, :flags

    def initialize(episode:, scene_id: nil, location: "", time_period: "", money: 0, characters: {}, inventory: [], flags: {})
      @episode = episode.to_s.freeze
      @scene_id = scene_id ? scene_id.to_s : nil
      @location = location.to_s
      @time_period = time_period.to_s
      @money = money.to_i
      @characters = {}
      @inventory = inventory.map(&:to_sym)
      @flags = flags.transform_keys(&:to_sym)

      characters.each_value do |char|
        add_character(char)
      end
    end

    def add_character(char)
      raise ArgumentError, "Expected Character instance" unless char.is_a?(Character)
      @characters[char.id] = char
    end

    def character(id)
      @characters[id.to_sym]
    end

    def has_character?(id)
      @characters.key?(id.to_sym)
    end

    def add_item(item)
      sym = item.to_sym
      @inventory << sym unless @inventory.include?(sym)
      @inventory
    end

    def remove_item(item)
      @inventory.delete(item.to_sym)
    end

    def has_item?(item)
      @inventory.include?(item.to_sym)
    end

    def adjust_money(delta)
      @money += delta.to_i
      @money
    end

    def set_flag(key, value)
      @flags[key.to_sym] = value
    end

    def flag(key, default = nil)
      @flags.fetch(key.to_sym, default)
    end

    def flag?(key)
      !!@flags[key.to_sym]
    end

    def deep_clone
      cloned_chars = {}
      @characters.each do |k, v|
        cloned_chars[k] = v.deep_clone
      end

      WorldState.new(
        episode: @episode,
        scene_id: @scene_id,
        location: @location.dup,
        time_period: @time_period.dup,
        money: @money,
        characters: cloned_chars,
        inventory: @inventory.dup,
        flags: @flags.dup
      )
    end
  end
end
