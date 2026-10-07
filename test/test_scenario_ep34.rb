# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep34"

class TestScenarioEp34 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep34.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 34 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:takabe_on_warpath)
    assert final_state.flag?(:restaurant_row_objective_active)
    assert outcome[:events].has_event?("story.yakuza_murders_reported")
    assert outcome[:events].has_event?("story.conspiracy_deduced")
  end

  def test_precondition_call_fails_without_surface_signal
    scene = IchibanLab::Scene.new(id: :phone_call_with_hoshino)
    scene.add_precondition("El grupo debe haber alcanzado la superficie") { |ws| ws.flag?(:reached_surface) }

    invalid_state = IchibanLab::WorldState.new(episode: "34", flags: { reached_surface: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_34_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "34")
    assert_equal 0, status.exitstatus, "El CLI de episodio 34 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 34_la_chispa_del_conflicto"
  end
end
