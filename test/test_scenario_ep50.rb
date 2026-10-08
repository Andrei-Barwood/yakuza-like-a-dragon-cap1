# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep50"

class TestScenarioEp50 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep50.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 50 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:totsuka_subdued)
    assert final_state.flag?(:hamako_protected)
    assert_equal "Residencia de Hamako - Distrito Comercial", final_state.location

    call_event = outcome[:events].find_event("story.distress_call_received")
    refute_nil call_event
    assert_equal :hamako, call_event.actor

    schism_event = outcome[:events].find_event("story.seiryu_schism_revealed")
    refute_nil schism_event
    assert_equal :totsuka, schism_event.actor

    combat_event = outcome[:events].find_event("story.combat_resolved")
    refute_nil combat_event
    assert_equal true, combat_event.data[:victory]
  end

  def test_precondition_fails_without_survive_hideout
    scene = IchibanLab::Scene.new(id: :hamako_distress_call)
    scene.add_precondition("El grupo debe haber descansado en Survive Bar") do |ws|
      ws.flag?(:survive_hideout_unlocked)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "50", flags: { survive_hideout_unlocked: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_50_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "50")
    assert_equal 0, status.exitstatus, "El CLI de episodio 50 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 50_el_contraataque_de_totsuka"
  end
end
