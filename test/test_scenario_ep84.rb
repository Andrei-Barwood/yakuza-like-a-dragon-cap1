# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep84"

class TestScenarioEp84 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep84.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 84 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ishioda_floors_cleared)
    assert final_state.flag?(:traffic_quiz_solved)
    assert final_state.flag?(:tendo_culprit_revealed)
    assert final_state.flag?(:chapter_14_completed)

    impersonation_event = outcome[:events].find_event("story.mirror_face_adachi_impersonation")
    refute_nil impersonation_event
    assert_equal :mirror_face, impersonation_event.actor

    quiz_event = outcome[:events].find_event("story.traffic_laws_quiz_breakthrough")
    refute_nil quiz_event
    assert_equal :ichiban, quiz_event.actor
    assert_includes quiz_event.data[:trick], "codigo_de_circulacion"

    confession_event = outcome[:events].find_event("story.ishioda_confession_tendo_murdered_arakawa")
    refute_nil confession_event
    assert_equal :akira_ishioda, confession_event.actor
    assert_includes confession_event.data[:truth], "tendo_disparo_a_quema_ropa"

    bomb_event = outcome[:events].find_event("story.tendo_bomb_detonation_trap")
    refute_nil bomb_event
    assert_equal :yosuke_tendo, bomb_event.actor

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 14, boundary_event.data[:chapter]
    assert_equal :chapter_15, boundary_event.data[:next]
  end

  def test_precondition_fails_without_ep83_completion
    scene = IchibanLab::Scene.new(id: :bar_district_building_ascent)
    scene.add_precondition("El objetivo del Bar District debe estar fijado") do |ws|
      ws.flag?(:ep83_completed) && ws.flag?(:bar_district_target_confirmed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "84", flags: { ep83_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_84_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "84")
    assert_equal 0, status.exitstatus, "El CLI de episodio 84 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 84_fuego_cruzado_en_el_distrito_de_bares"
  end
end
