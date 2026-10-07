# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep17"

class TestScenarioEp17 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep17.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 17 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:geomijul_standoff_survived)
    assert final_state.flag?(:harbor_light_defended)
    assert_equal 6300, final_state.money
    assert_equal :trusted_ally, final_state.character(:ichiban).relationship(:hamako)
  end

  def test_precondition_briefing_fails_without_job_acceptance
    scene = IchibanLab::Scene.new(id: :harbor_light_briefing)
    scene.add_precondition("Debe haber aceptado el trabajo en Hello Work") { |ws| ws.flag?(:harbor_light_job_accepted) }

    invalid_state = IchibanLab::WorldState.new(episode: "17", flags: { harbor_light_job_accepted: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_17_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "17")
    assert_equal 0, status.exitstatus, "El CLI de episodio 17 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 17_defensa_de_harbor_light"
  end
end
