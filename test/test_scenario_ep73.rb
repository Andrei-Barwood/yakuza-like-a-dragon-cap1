# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep73"

class TestScenarioEp73 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep73.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 73 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:police_cordon_restrained)
    assert final_state.flag?(:heian_briefing_received)
    assert final_state.flag?(:tokyo_omi_tension_escalated)
    assert final_state.flag?(:ep73_completed)
    assert_equal "Kamurocho - Sede Provisional", final_state.location

    cordon_event = outcome[:events].find_event("story.arakawa_corpse_cordon_rush")
    refute_nil cordon_event
    assert_equal :ichiban, cordon_event.actor
    assert_equal :police, cordon_event.target

    briefing_event = outcome[:events].find_event("story.takabe_briefing_last_dinner")
    refute_nil briefing_event
    assert_equal :mamoru_takabe, briefing_event.actor
    assert_equal :adachi, briefing_event.target

    feud_event = outcome[:events].find_event("story.sawashiro_ishioda_feud")
    refute_nil feud_event
    assert_equal :jo_sawashiro, feud_event.actor
    assert_equal :akira_ishioda, feud_event.target
  end

  def test_precondition_fails_without_arakawa_deceased
    scene = IchibanLab::Scene.new(id: :coastal_pier_crime_scene)
    scene.add_precondition("El cadáver de Arakawa debe haber sido reportado") do |ws|
      ws.flag?(:arakawa_deceased) && ws.flag?(:chapter_12_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "73", flags: { arakawa_deceased: false, chapter_12_completed: true })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_73_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "73")
    assert_equal 0, status.exitstatus, "El CLI de episodio 73 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 73_el_dolor_en_el_muelle"
  end
end
