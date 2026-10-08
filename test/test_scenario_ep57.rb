# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep57"

class TestScenarioEp57 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep57.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 57 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:tiger_defeated)
    assert final_state.flag?(:mabuchi_overthrown)
    assert_equal "Restaurante Qing Jin - Salón Superior", final_state.location

    tiger_event = outcome[:events].find_event("story.beast_unleashed")
    refute_nil tiger_event

    tendo_event = outcome[:events].find_event("story.tendo_introduced")
    refute_nil tendo_event
    assert_equal :yosuke_tendo, tendo_event.actor

    boss_event = outcome[:events].find_event("story.boss_defeated")
    refute_nil boss_event
    assert_equal :akira_mabuchi, boss_event.target
  end

  def test_precondition_fails_without_qing_jin_infiltrated
    scene = IchibanLab::Scene.new(id: :qing_jin_tiger_gauntlet)
    scene.add_precondition("Qing Jin debe haber sido infiltrado") do |ws|
      ws.flag?(:qing_jin_infiltrated)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "57", flags: { qing_jin_infiltrated: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_57_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "57")
    assert_equal 0, status.exitstatus, "El CLI de episodio 57 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 57_el_dragon_y_el_tigre"
  end
end
