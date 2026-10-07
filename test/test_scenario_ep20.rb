# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep20"

class TestScenarioEp20 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep20.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 20 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:sunlight_castle_located)
    assert_equal :employer, final_state.character(:ichiban).relationship(:nonomiya)
  end

  def test_precondition_briefing_fails_without_job_assignment
    scene = IchibanLab::Scene.new(id: :otohime_land_briefing)
    scene.add_precondition("Ichiban debe haber sido contratado por Nonomiya") { |ws| ws.flag?(:otohime_land_assigned) }

    invalid_state = IchibanLab::WorldState.new(episode: "20", flags: { otohime_land_assigned: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_20_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "20")
    assert_equal 0, status.exitstatus, "El CLI de episodio 20 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 20_otohime_land"
  end
end
