# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep65"

class TestScenarioEp65 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep65.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 65 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:suzumori_true_killer_known)
    assert final_state.flag?(:aoki_talks_broken)

    transplant_event = outcome[:events].find_event("story.aoki_transplant_and_erasure_revealed")
    refute_nil transplant_event
    assert_equal "operacion_en_estados_unidos", transplant_event.data[:lung_transplant]

    hit_event = outcome[:events].find_event("story.ogasawara_hit_ordered_by_aoki")
    refute_nil hit_event
    assert_equal "control_de_riesgos_sabia_demasiado", hit_event.data[:justification]

    killer_event = outcome[:events].find_event("story.suzumori_murder_true_killer_revealed")
    refute_nil killer_event
    assert_equal "masato_arakawa", killer_event.data[:real_killer]

    deportation_event = outcome[:events].find_event("story.revitalization_plan_deportation_scheme_exposed")
    refute_nil deportation_event
    assert_includes deportation_event.data[:true_goal], "deportacion_masiva"
  end

  def test_precondition_fails_without_meeting_scheduled
    scene = IchibanLab::Scene.new(id: :otohime_land_night_meeting)
    scene.add_precondition("Kasuga debe haber acudido a la cita privada") do |ws|
      ws.flag?(:otohime_meeting_scheduled)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "65", flags: { otohime_meeting_scheduled: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_65_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "65")
    assert_equal 0, status.exitstatus, "El CLI de episodio 65 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 65_la_noche_en_otohime_land"
  end
end
