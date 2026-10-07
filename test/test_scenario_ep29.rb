# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep29"

class TestScenarioEp29 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep29.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 29 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:printing_press_suspected)
    assert final_state.flag?(:counterfeit_yuan_operation_confirmed)
    assert final_state.flag?(:sample_extraction_ready)
  end

  def test_precondition_shortage_fails_without_dock_active
    scene = IchibanLab::Scene.new(id: :cash_shortage_incident)
    scene.add_precondition("La infiltración en el muelle debe continuar activa") { |ws| ws.flag?(:dock_infiltration_active) }

    invalid_state = IchibanLab::WorldState.new(episode: "29", flags: { dock_infiltration_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_29_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "29")
    assert_equal 0, status.exitstatus, "El CLI de episodio 29 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 29_la_imprenta_clandestina"
  end
end
