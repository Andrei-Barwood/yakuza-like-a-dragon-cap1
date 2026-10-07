# frozen_string_literal: true

require "time"

module IchibanLab
  class Event
    attr_reader :id, :episode, :scene, :actor, :target, :data, :sequence, :timestamp

    def initialize(id:, episode:, scene:, actor: nil, target: nil, data: {}, sequence: 0, timestamp: Time.now)
      raise ArgumentError, "Event id is required" if id.nil? || id.to_s.strip.empty?
      raise ArgumentError, "Event episode is required" if episode.nil? || episode.to_s.strip.empty?
      raise ArgumentError, "Event scene is required" if scene.nil? || scene.to_s.strip.empty?

      @id = id.to_s.freeze
      @episode = episode.to_s.freeze
      @scene = scene.to_s.freeze
      @actor = actor ? actor.to_sym : nil
      @target = target ? target.to_sym : nil
      @data = (data || {}).dup.freeze
      @sequence = sequence.to_i
      @timestamp = timestamp.freeze
    end

    def to_h
      {
        sequence: @sequence,
        id: @id,
        episode: @episode,
        scene: @scene,
        actor: @actor,
        target: @target,
        data: @data,
        timestamp: @timestamp.iso8601
      }
    end

    def matches?(id: nil, actor: nil, target: nil, scene: nil)
      return false if id && @id != id.to_s
      return false if actor && @actor != actor.to_sym
      return false if target && @target != target.to_sym
      return false if scene && @scene != scene.to_s
      true
    end
  end

  class EventLog
    include Enumerable

    def initialize
      @events = []
    end

    def emit(id, episode:, scene:, actor: nil, target: nil, data: {})
      seq = @events.size + 1
      event = Event.new(
        id: id,
        episode: episode,
        scene: scene,
        actor: actor,
        target: target,
        data: data,
        sequence: seq
      )
      @events << event
      event
    end

    def each(&block)
      @events.each(&block)
    end

    def size
      @events.size
    end

    def empty?
      @events.empty?
    end

    def last
      @events.last
    end

    def all
      @events.dup
    end

    def filter(id: nil, actor: nil, target: nil, scene: nil)
      @events.select { |e| e.matches?(id: id, actor: actor, target: target, scene: scene) }
    end

    def has_event?(id)
      @events.any? { |e| e.id == id.to_s }
    end

    def find_event(id)
      @events.find { |e| e.id == id.to_s }
    end
  end
end
