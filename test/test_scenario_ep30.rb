# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep30"

class TestScenarioEp30 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep30.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 30 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.has_item?(:counterfeit_yuan_sample)
    assert final_state.flag?(:fuel_leak_triggered)
    assert final_state.flag?(:warehouse_destroyed)
    assert final_state.flag?(:chapter_5_completed)

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 5, boundary_event.data[:chapter]
    assert_equal :concluded, boundary_event.data[:status]
    assert_equal :chapter_6, boundary_event.data[:next]
  end

  def test_precondition_fumble_fails_without_sample_plan
    scene = IchibanLab::Scene.new(id: :handover_fumble_and_clash)
    scene.add_precondition("El plan de extracción de muestra debe estar preparado") { |ws| ws.flag?(:sample_extraction_ready) }

    invalid_state = IchibanLab::WorldState.new(episode: "30", flags: { sample_extraction_ready: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_30_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "30")
    assert_equal 0, status.exitstatus, "El CLI de episodio 30 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 30_explosion_en_el_muelle"
  end
end
