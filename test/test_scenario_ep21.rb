# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep21"

class TestScenarioEp21 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep21.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 21 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:infiltrated_sunlight_castle)
    assert final_state.flag?(:vip_screams_heard)
    assert final_state.flag?(:pension_scam_uncovered)
    assert final_state.flag?(:tatsuro_rescue_urgent)
  end

  def test_precondition_placement_fails_without_castle_location
    scene = IchibanLab::Scene.new(id: :kanbe_placement)
    scene.add_precondition("Sunlight Castle debe haber sido localizado") { |ws| ws.flag?(:sunlight_castle_located) }

    invalid_state = IchibanLab::WorldState.new(episode: "21", flags: { sunlight_castle_located: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_21_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "21")
    assert_equal 0, status.exitstatus, "El CLI de episodio 21 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 21_el_castillo_de_la_luz"
  end
end
