# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep33"

class TestScenarioEp33 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep33.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 33 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:yan_excavator_defeated)
    assert final_state.flag?(:reached_surface)
    assert_equal "Distrito Comercial de Isezaki Ijincho - Callejón Trasero", final_state.location
    assert outcome[:events].has_event?("story.heavy_machinery_assault")
  end

  def test_precondition_ascent_fails_without_gear_and_freedom
    scene = IchibanLab::Scene.new(id: :smuggling_tunnel_climb)
    scene.add_precondition("El grupo debe haber recuperado su equipamiento y libertad") do |ws|
      ws.flag?(:gear_recovered) && ws.flag?(:party_freed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "33", flags: { gear_recovered: false, party_freed: true })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_33_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "33")
    assert_equal 0, status.exitstatus, "El CLI de episodio 33 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 33_el_duelo_de_la_excavadora"
  end
end
