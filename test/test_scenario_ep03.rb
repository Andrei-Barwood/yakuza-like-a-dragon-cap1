# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep03"
require "open3"

class TestScenarioEp03 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep03.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "03_encargo_urgente", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Shangri-La", state.location
    assert state.flag?(:favor_accepted)
    assert state.flag?(:elderly_protected)
    assert state.flag?(:plunger_acquired)
    assert state.flag?(:shangri_la_unclogged)
    assert state.flag?(:mitsuo_called)
    assert_equal :hiratsuka, state.flag(:next_assignment_target)

    # El desatascador fue utilizado (removido del inventario)
    refute state.has_item?(:heavy_duty_plunger)

    events = outcome[:events]
    assert events.has_event?("story.objective_started")
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.item_acquired")
    assert events.has_event?("story.objective_completed")
    assert events.has_event?("story.communication_received")
  end

  def test_precondition_shangri_la_fails_without_plunger
    scene = IchibanLab::Scene.new(id: :shangri_la_resolution)
    scene.add_precondition("Ichiban debe tener el desatascador") { |ws| ws.has_item?(:heavy_duty_plunger) }

    raw_state = @scenario.send(:default_initial_state)
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(raw_state)
    end
  end

  def test_bin_episodio_03_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "03")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 03: UN FAVOR EN EL BARRIO"
    assert_includes stdout, "story.objective_completed"
  end
end
