# frozen_string_literal: true

require_relative "test_helper"

class TestEventLog < Minitest::Test
  def setup
    @log = IchibanLab::EventLog.new
  end

  def test_emit_and_retrieve_events
    ev = @log.emit("story.objective_started", episode: "02_cobranza", scene: "intro", actor: :ichiban, data: { task: "collect" })
    assert_equal 1, @log.size
    assert_equal "story.objective_started", ev.id
    assert_equal "02_cobranza", ev.episode
    assert_equal "intro", ev.scene
    assert_equal :ichiban, ev.actor
    assert_equal 1, ev.sequence
    assert_equal({ task: "collect" }, ev.data)
  end

  def test_filtering_events
    @log.emit("story.objective_started", episode: "02", scene: "intro", actor: :ichiban)
    @log.emit("story.combat_resolved", episode: "02", scene: "alley", actor: :ichiban, target: :ushio)
    @log.emit("story.choice_recorded", episode: "02", scene: "alley", actor: :mitsuo)

    combat_events = @log.filter(id: "story.combat_resolved")
    assert_equal 1, combat_events.size
    assert_equal :ushio, combat_events.first.target

    alley_events = @log.filter(scene: "alley")
    assert_equal 2, alley_events.size

    assert @log.has_event?("story.combat_resolved")
    refute @log.has_event?("story.non_existent")
  end
end
