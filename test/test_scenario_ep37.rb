# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep37"

class TestScenarioEp37 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep37.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 37 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:mysterious_woman_followed)
    assert final_state.flag?(:geomijul_entrance_reached)
    assert_equal "Edificio Abandonado de Geomijul - Fachada", final_state.location
    assert outcome[:events].has_event?("story.intel_mission_started")
    assert outcome[:events].has_event?("story.spider_web_discovered")
  end

  def test_precondition_koreatown_fails_without_geomijul_lead
    scene = IchibanLab::Scene.new(id: :koreatown_investigation)
    scene.add_precondition("La pista de Geomijul debe estar activa") { |ws| ws.flag?(:geomijul_lead_unlocked) }

    invalid_state = IchibanLab::WorldState.new(episode: "37", flags: { geomijul_lead_unlocked: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_37_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "37")
    assert_equal 0, status.exitstatus, "El CLI de episodio 37 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 37_el_barrio_coreano"
  end
end
