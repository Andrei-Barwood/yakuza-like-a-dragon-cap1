# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep11"
require "open3"

class TestScenarioEp11 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep11.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "11_los_bajos_fondos", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Sótano del Edificio de la Cumbre", state.location
    assert state.flag?(:sewer_navigated)
    assert state.flag?(:sewer_guards_defeated)
    assert state.flag?(:access_hatch_opened)
    assert state.flag?(:building_infiltrated)
    assert_equal :storm_executive_floor, state.flag(:next_step)

    events = outcome[:events]
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.objective_completed")
  end

  def test_precondition_descent_fails_without_adachi
    scene = IchibanLab::Scene.new(id: :sewer_descent)
    scene.add_precondition("Debe haber orden de entrar y tener a Adachi") do |ws|
      ws.flag(:next_step) == :enter_underground_sewers && ws.has_character?(:adachi)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "11", flags: { next_step: :enter_underground_sewers })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_11_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "11")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 11: LOS CONDUCTOS SUBTERRÁNEOS"
    assert_includes stdout, "story.objective_completed"
  end
end
