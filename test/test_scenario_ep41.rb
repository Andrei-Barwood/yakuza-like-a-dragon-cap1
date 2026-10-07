# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep41"

class TestScenarioEp41 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep41.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 41 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:nanba_rescued_and_fled)
    assert final_state.flag?(:heian_tower_summons_active)
    assert outcome[:events].has_event?("story.loyalty_proclaimed")
    assert outcome[:events].has_event?("story.boss_defeated")
    assert outcome[:events].has_event?("story.summons_issued")
  end

  def test_precondition_loyalty_fails_without_nanba_capture
    scene = IchibanLab::Scene.new(id: :loyalty_defense_and_han_duel)
    scene.add_precondition("Nanba debe haber sido capturado") { |ws| ws.flag?(:nanba_captured_by_geomijul) }

    invalid_state = IchibanLab::WorldState.new(episode: "41", flags: { nanba_captured_by_geomijul: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_41_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "41")
    assert_equal 0, status.exitstatus, "El CLI de episodio 41 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 41_el_rescate_de_nanba"
  end
end
