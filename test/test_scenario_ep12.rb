# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep12"
require "open3"

class TestScenarioEp12 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep12.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "12_el_guantelete", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Puertas del Despacho", state.location
    assert state.flag?(:executive_floor_breached)
    assert state.flag?(:sawashiro_boss_defeated)
    assert state.flag?(:adachi_holding_corridor)
    assert state.flag?(:path_to_arakawa_opened)

    sawashiro = state.character(:sawashiro)
    assert_equal :defeated, sawashiro.attribute(:status)
    assert_equal 0, sawashiro.attribute(:hp)

    events = outcome[:events]
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.objective_completed")
  end

  def test_precondition_stairs_fails_without_building_infiltration
    scene = IchibanLab::Scene.new(id: :stairs_breach_to_executive_floor)
    scene.add_precondition("El edificio debe haber sido infiltrado") { |ws| ws.flag?(:building_infiltrated) }

    invalid_state = IchibanLab::WorldState.new(episode: "12", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_12_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "12")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 12: DUELO CON SAWASHIRO"
    assert_includes stdout, "story.combat_resolved"
  end
end
