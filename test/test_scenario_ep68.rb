# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep68"

class TestScenarioEp68 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep68.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 68 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:dragon_chamber_location_known)
    assert final_state.flag?(:catering_disguise_ready)
    assert_equal "Exterior del Cuartel General de la Omi - Osaka", final_state.location

    sotenbori_event = outcome[:events].find_event("story.sotenbori_tension_observed")
    refute_nil sotenbori_event
    assert_equal :ichiban, sotenbori_event.actor

    mitsuo_event = outcome[:events].find_event("story.mitsuo_dragon_chamber_alert")
    refute_nil mitsuo_event
    assert_equal :mitsuo, mitsuo_event.actor
    assert_equal 3, mitsuo_event.data[:secret_guests]

    disguise_event = outcome[:events].find_event("story.catering_infiltration_resolved")
    refute_nil disguise_event
    assert_equal "camareros_de_catering", disguise_event.data[:disguise]
  end

  def test_precondition_fails_without_watase_release_status
    scene = IchibanLab::Scene.new(id: :sotenbori_arrival_and_grand_wait)
    scene.add_precondition("La liberación de Watase debe estar en curso") do |ws|
      ws.flag?(:watase_release_imminent)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "68", flags: { watase_release_imminent: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_68_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "68")
    assert_equal 0, status.exitstatus, "El CLI de episodio 68 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 68_rumbo_a_sotenbori"
  end
end
