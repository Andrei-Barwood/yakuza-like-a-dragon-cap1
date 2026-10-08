# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep70"

class TestScenarioEp70 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep70.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 70 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:plan_3k_truth_understood)
    assert final_state.flag?(:joint_dissolution_proclaimed)
    assert_equal "Cuartel General Omi - Salón de Asambleas", final_state.location

    truth_event = outcome[:events].find_event("story.plan_3k_true_purpose_revealed")
    refute_nil truth_event
    assert_equal :daigo_dojima, truth_event.actor

    dissolution_event = outcome[:events].find_event("story.joint_dissolution_proclaimed")
    refute_nil dissolution_event
    assert_equal :masaru_watase, dissolution_event.actor

    rebellion_event = outcome[:events].find_event("story.omi_rebellion_sparked")
    refute_nil rebellion_event
    assert_equal :masaru_watase, rebellion_event.actor
  end

  def test_precondition_fails_without_tojo_legends_alliance
    scene = IchibanLab::Scene.new(id: :plan_3k_truth_revealed)
    scene.add_precondition("La alianza de leyendas debe haberse confirmado") do |ws|
      ws.flag?(:tojo_legends_alliance_confirmed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "70", flags: { tojo_legends_alliance_confirmed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_70_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "70")
    assert_equal 0, status.exitstatus, "El CLI de episodio 70 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 70_el_pacto_de_disolucion"
  end
end
