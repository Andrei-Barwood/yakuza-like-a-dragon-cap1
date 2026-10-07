# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep26"

class TestScenarioEp26 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep26.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 26 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:yokohama_trading_identified)
  end

  def test_precondition_vip_fails_without_saeko_in_party
    scene = IchibanLab::Scene.new(id: :lin_lin_vip_infiltration)
    scene.add_precondition("Saeko debe estar integrada en el grupo de investigación") { |ws| ws.flag?(:saeko_joined_party) }

    invalid_state = IchibanLab::WorldState.new(episode: "26", flags: { saeko_joined_party: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_26_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "26")
    assert_equal 0, status.exitstatus, "El CLI de episodio 26 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 26_el_club_lin_lin"
  end
end
