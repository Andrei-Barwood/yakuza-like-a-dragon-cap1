# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep28"

class TestScenarioEp28 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep28.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 28 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:bleach_japan_humiliated)
    assert final_state.flag?(:local_community_allies)
  end

  def test_precondition_protest_fails_without_dock_active
    scene = IchibanLab::Scene.new(id: :bleach_japan_otohime_protest)
    scene.add_precondition("La infiltración inicial en el muelle debe estar activa") { |ws| ws.flag?(:dock_infiltration_active) }

    invalid_state = IchibanLab::WorldState.new(episode: "28", flags: { dock_infiltration_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_28_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "28")
    assert_equal 0, status.exitstatus, "El CLI de episodio 28 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 28_la_resistencia_vecinal"
  end
end
