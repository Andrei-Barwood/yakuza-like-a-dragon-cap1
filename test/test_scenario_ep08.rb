# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep08"
require "open3"

class TestScenarioEp08 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep08.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "08_liberacion", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Ruta hacia Kamurocho", state.location
    assert_equal "2019 - Día", state.time_period
    assert_equal 500, state.money
    assert state.flag?(:released_from_prison)
    assert state.flag?(:adachi_contacted)
    assert state.flag?(:ambush_survived)
    assert state.flag?(:heard_arakawa_betrayal)
    assert_equal :kamurocho, state.flag(:destination)

    assert state.has_character?(:adachi)

    events = outcome[:events]
    assert events.has_event?("story.prison_release")
    assert events.has_event?("story.character_introduced")
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.information_revealed")
    assert events.has_event?("story.objective_started")
  end

  def test_precondition_revelation_fails_without_ambush_survival
    scene = IchibanLab::Scene.new(id: :revelation_of_the_fall)
    scene.add_precondition("Los agresores deben haber sido neutralizados") { |ws| ws.flag?(:ambush_survived) }

    invalid_state = IchibanLab::WorldState.new(episode: "08", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_08_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "08")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 08: 18 AÑOS DESPUÉS"
    assert_includes stdout, "story.prison_release"
  end
end
