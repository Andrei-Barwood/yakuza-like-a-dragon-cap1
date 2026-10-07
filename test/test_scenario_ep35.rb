# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep35"

class TestScenarioEp35 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep35.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 35 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:takabe_subdued)
    assert_equal "Restaurante Qing Jin - Puertas Exteriores", final_state.location
    assert outcome[:events].has_event?("story.gunshot_warning")
    assert outcome[:events].has_event?("story.honor_duel_initiated")
    assert outcome[:events].has_event?("story.boss_defeated")
  end

  def test_precondition_row_fails_without_objective
    scene = IchibanLab::Scene.new(id: :restaurant_row_carnage_entry)
    scene.add_precondition("El objetivo debe estar activo") { |ws| ws.flag?(:restaurant_row_objective_active) }

    invalid_state = IchibanLab::WorldState.new(episode: "35", flags: { restaurant_row_objective_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_35_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "35")
    assert_equal 0, status.exitstatus, "El CLI de episodio 35 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 35_camino_a_restaurant_row"
  end
end
