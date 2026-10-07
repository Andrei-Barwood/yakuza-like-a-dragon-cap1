# frozen_string_literal: true

module IchibanLab
  class Scene
    attr_reader :id, :title, :location, :actions

    def initialize(id:, title: "", location: "", actions: [])
      raise ArgumentError, "Scene id is required" if id.nil? || id.to_s.strip.empty?

      @id = id.to_sym
      @title = title.to_s.freeze
      @location = location.to_s.freeze
      @actions = actions.dup
      @preconditions = []
    end

    def add_precondition(description = "Precondition failed", &block)
      raise ArgumentError, "Block required for precondition" unless block_given?
      @preconditions << { description: description, check: block }
      self
    end

    def check_preconditions!(world_state)
      @preconditions.each do |pre|
        satisfied = begin
          pre[:check].call(world_state)
        rescue StandardError => e
          raise PreconditionError, "Precondition error in scene '#{@id}': #{e.message}"
        end

        unless satisfied
          raise PreconditionError, "Precondition not met for scene '#{@id}': #{pre[:description]}"
        end
      end
      true
    end
  end
end
