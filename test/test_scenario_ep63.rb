# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep63"

class TestScenarioEp63 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep63.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 63 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:kume_candidacy_announced)
    assert final_state.flag?(:underground_parking_target_active)

    restriction_event = outcome[:events].find_event("story.funeral_hall_restricted")
    refute_nil restriction_event
    assert_equal "solo_familiares_y_cupula_de_bleach_japan", restriction_event.data[:access_rule]

    eulogy_event = outcome[:events].find_event("story.aoki_eulogy_delivered")
    refute_nil eulogy_event
    assert_equal :ryo_aoki, eulogy_event.actor
    assert_equal :sota_kume, eulogy_event.target

    parking_event = outcome[:events].find_event("story.underground_parking_route_deduced")
    refute_nil parking_event
    assert_equal :saeko, parking_event.actor
  end

  def test_precondition_fails_without_funeral_target
    scene = IchibanLab::Scene.new(id: :funeral_home_exterior_and_restriction)
    scene.add_precondition("El grupo debe conocer la ubicación del funeral") do |ws|
      ws.flag?(:funeral_target_identified)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "63", flags: { funeral_target_identified: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_63_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "63")
    assert_equal 0, status.exitstatus, "El CLI de episodio 63 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 63_el_funeral_de_ogasawara"
  end
end
