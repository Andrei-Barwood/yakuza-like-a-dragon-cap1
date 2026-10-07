# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep44"

class TestScenarioEp44 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep44.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 44 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:kasuga_rejected_betrayal)
    assert final_state.flag?(:hakuryo_building_target_active)

    refusal_event = outcome[:events].find_event("story.loyalty_refusal")
    refute_nil refusal_event
    assert_equal :ichiban, refusal_event.actor
    assert_equal :tianyou_zhao, refusal_event.target

    deduction_event = outcome[:events].find_event("story.deduction_relayed")
    refute_nil deduction_event
    assert_equal :joon_gi_han, deduction_event.actor
    assert_includes deduction_event.data[:target_location], "Hakuryo"
  end

  def test_precondition_fails_without_ogikubo_system_understanding
    scene = IchibanLab::Scene.new(id: :nanba_ultimatum_discussion)
    scene.add_precondition("El sistema de Ogikubo debe haber sido comprendido") do |ws|
      ws.flag?(:ogikubo_system_fully_understood)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "44", flags: { ogikubo_system_fully_understood: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_44_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "44")
    assert_equal 0, status.exitstatus, "El CLI de episodio 44 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 44_el_dilema_de_la_lealtad"
  end
end
