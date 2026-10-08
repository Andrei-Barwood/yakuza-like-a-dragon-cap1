# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep74"

class TestScenarioEp74 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep74.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 74 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:mourning_call_answered)
    assert final_state.flag?(:peking_duck_memory_shared)
    assert final_state.flag?(:arakawa_ideal_reaffirmed)
    assert final_state.flag?(:ep74_completed)

    call_event = outcome[:events].find_event("story.hoshino_survive_bar_call")
    refute_nil call_event
    assert_equal :tianyou_zhao, call_event.actor
    assert_equal :ichiban, call_event.target

    peace_event = outcome[:events].find_event("story.heian_tower_arakawa_peace")
    refute_nil peace_event
    assert_equal :ryuhei_hoshino, peace_event.actor
    assert_includes peace_event.data[:peking_duck], "pato_de_pekin"

    vow_event = outcome[:events].find_event("story.kasuga_vow_of_restoration")
    refute_nil vow_event
    assert_equal :ichiban, vow_event.actor
    assert_equal :ryuhei_hoshino, vow_event.target
  end

  def test_precondition_fails_without_ep73_completion
    scene = IchibanLab::Scene.new(id: :survive_bar_mourning_call)
    scene.add_precondition("El episodio 73 debe haber finalizado") do |ws|
      ws.flag?(:ep73_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "74", flags: { ep73_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_74_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "74")
    assert_equal 0, status.exitstatus, "El CLI de episodio 74 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 74_el_lamento_y_la_determinacion"
  end
end
