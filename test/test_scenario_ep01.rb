# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep01"
require "open3"

class TestScenarioEp01 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep01.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "01_origen", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Callejón trasero", state.location
    assert_equal "1977 - Noche", state.time_period
    assert state.flag?(:performance_finished)
    assert state.flag?(:dinner_shared)
    assert state.flag?(:ambush_occurred)
    assert state.flag?(:toshio_deceased)
    assert state.flag?(:vow_recorded)

    toshio = state.character(:toshio)
    assert_equal :deceased, toshio.attribute(:status)
    assert_equal 0, toshio.attribute(:hp)

    masumi = state.character(:masumi)
    assert_equal :father_killed, masumi.attribute(:trauma)
    assert masumi.has_belonging?(:family_talisman)

    events = outcome[:events]
    assert events.has_event?("story.scenario_started")
    assert events.has_event?("story.objective_started")
    assert events.has_event?("story.meal_shared")
    assert events.has_event?("story.ambush_triggered")
    assert events.has_event?("story.sacrifice_recorded")
    assert events.has_event?("story.chapter_boundary")
    assert events.has_event?("story.scenario_completed")
  end

  def test_precondition_dinner_fails_without_performance
    dinner_scene = IchibanLab::Scene.new(id: :dinner_at_eatery)
    dinner_scene.add_precondition("La función debe haber concluido") { |ws| ws.flag?(:performance_finished) }

    raw_state = @scenario.send(:default_initial_state)
    assert_raises(IchibanLab::PreconditionError) do
      dinner_scene.check_preconditions!(raw_state)
    end
  end

  def test_bin_episodio_01_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "01")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 01: LA PRIMERA DEUDA"
    assert_includes stdout, "story.sacrifice_recorded"
  end
end
