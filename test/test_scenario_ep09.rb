# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep09"
require "open3"

class TestScenarioEp09 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep09.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "09_el_nuevo_kamurocho", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Nakamichi Street", state.location
    assert_equal "2019 - Tarde", state.time_period
    assert_equal 3500, state.money
    assert state.flag?(:kamurocho_entered)
    assert state.flag?(:old_office_inspected)
    assert state.flag?(:omi_patrol_defeated)
    assert state.flag?(:summit_meeting_discovered)
    assert_equal :find_way_into_summit, state.flag(:next_objective)

    events = outcome[:events]
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.information_revealed")
    assert events.has_event?("story.objective_started")
  end

  def test_precondition_arrival_fails_without_destination
    scene = IchibanLab::Scene.new(id: :tenkaichi_gate_arrival)
    scene.add_precondition("El destino debe ser Kamurocho") { |ws| ws.flag(:destination) == :kamurocho }

    invalid_state = IchibanLab::WorldState.new(episode: "09", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_09_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "09")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 09: EL NUEVO KAMUROCHO"
    assert_includes stdout, "story.combat_resolved"
  end
end
