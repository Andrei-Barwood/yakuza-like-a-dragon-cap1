# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep40"

class TestScenarioEp40 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep40.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 40 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:shoichi_mystery_revealed)
    assert final_state.flag?(:nanba_captured_by_geomijul)
    assert outcome[:events].has_event?("story.surveillance_history_revealed")
    assert outcome[:events].has_event?("story.confession_unsealed")
    assert outcome[:events].has_event?("story.taser_subdual")
  end

  def test_precondition_interrogation_fails_without_suspicions
    scene = IchibanLab::Scene.new(id: :nanba_background_interrogation)
    scene.add_precondition("Las sospechas sobre Nanba deben estar activas") { |ws| ws.flag?(:nanba_suspicions_triggered) }

    invalid_state = IchibanLab::WorldState.new(episode: "40", flags: { nanba_suspicions_triggered: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_40_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "40")
    assert_equal 0, status.exitstatus, "El CLI de episodio 40 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 40_la_confesion_de_nanba"
  end
end
