# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep22"

class TestScenarioEp22 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep22.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 22 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:survive_bar_unlocked)
    assert final_state.flag?(:ready_to_breach_sunlight)
    assert_equal :brother_in_arms, final_state.character(:ichiban).relationship(:adachi)
  end

  def test_precondition_arrival_fails_without_pension_scam_discovery
    scene = IchibanLab::Scene.new(id: :arrival_at_survive)
    scene.add_precondition("El fraude de Sunlight Castle debe estar al descubierto") { |ws| ws.flag?(:pension_scam_uncovered) }

    invalid_state = IchibanLab::WorldState.new(episode: "22", flags: { pension_scam_uncovered: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_22_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "22")
    assert_equal 0, status.exitstatus, "El CLI de episodio 22 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 22_la_noche_en_survive"
  end
end
