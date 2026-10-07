# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep27"

class TestScenarioEp27 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep27.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 27 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:job_system_available)
    assert final_state.flag?(:dock_infiltration_active)
  end

  def test_precondition_jobs_fails_without_trading_id
    scene = IchibanLab::Scene.new(id: :hello_work_job_system)
    scene.add_precondition("Yokohama Trading Company debe haber sido identificada") { |ws| ws.flag?(:yokohama_trading_identified) }

    invalid_state = IchibanLab::WorldState.new(episode: "27", flags: { yokohama_trading_identified: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_27_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "27")
    assert_equal 0, status.exitstatus, "El CLI de episodio 27 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 27_el_cambio_de_oficio"
  end
end
