# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep23"

class TestScenarioEp23 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep23.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 23 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.has_item?(:vip_keycard)
    assert final_state.flag?(:tatsuro_mukoda_rescued)
    assert final_state.flag?(:totsuka_defeated)
    assert final_state.flag?(:escorting_totsuka_to_seiryu)
  end

  def test_precondition_breach_fails_without_ready_flag
    scene = IchibanLab::Scene.new(id: :sunlight_castle_breach)
    scene.add_precondition("El grupo debe estar preparado para asaltar el asilo") { |ws| ws.flag?(:ready_to_breach_sunlight) }

    invalid_state = IchibanLab::WorldState.new(episode: "23", flags: { ready_to_breach_sunlight: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_23_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "23")
    assert_equal 0, status.exitstatus, "El CLI de episodio 23 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 23_el_rescate_de_tatsuro"
  end
end
