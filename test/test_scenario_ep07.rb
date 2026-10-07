# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep07"
require "open3"

class TestScenarioEp07 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep07.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "07_el_precio", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Centro de Detención de Kamurocho", state.location
    assert_equal "2001 - 1 de Enero (Tarde)", state.time_period
    assert_equal 0, state.money
    assert_empty state.inventory

    assert state.flag?(:sakaki_ambush_repelled)
    assert_equal :sawashiro_homicide, state.flag(:crime_revealed)
    assert state.flag?(:accepted_prison_sacrifice)
    assert state.flag?(:last_meal_consumed)
    assert state.flag?(:surrendered_to_police)
    assert state.flag?(:imprisoned)
    assert state.flag?(:chapter_1_completed)

    ichiban = state.character(:ichiban)
    assert_equal :prisoner, ichiban.attribute(:role)
    assert_equal :incarcerated, ichiban.attribute(:status)
    refute ichiban.has_belonging?(:arakawa_pin)

    events = outcome[:events]
    assert events.has_event?("story.emergency_call")
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.crime_confessed_privately")
    assert events.has_event?("story.choice_recorded")
    assert events.has_event?("story.meal_shared")
    assert events.has_event?("story.legal_surrender")

    boundary = events.find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 1, boundary.data[:chapter]
    assert_equal :out_of_scope, boundary.data[:next]
  end

  def test_precondition_awakening_fails_without_rest
    scene = IchibanLab::Scene.new(id: :new_years_awakening)
    scene.add_precondition("Ichiban debe haber descansado") { |ws| ws.flag?(:resting_for_night) }

    invalid_state = IchibanLab::WorldState.new(episode: "07", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_07_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "07")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 07: QUINCE AÑOS"
    assert_includes stdout, "Centro de Detención de Kamurocho"
    assert_includes stdout, "story.legal_surrender"
  end
end
