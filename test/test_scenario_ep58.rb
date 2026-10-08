# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep58"

class TestScenarioEp58 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep58.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 58 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ishioda_subdued)
    assert final_state.flag?(:nanba_permanently_rejoined)

    duel_event = outcome[:events].find_event("story.lieutenant_duel_initiated")
    refute_nil duel_event
    assert_equal :reiji_ishioda, duel_event.actor

    rejoin_event = outcome[:events].find_event("story.nanba_rejoined_combat")
    refute_nil rejoin_event
    assert_equal :nanba, rejoin_event.actor

    boss_event = outcome[:events].find_event("story.boss_defeated")
    refute_nil boss_event
    assert_equal :reiji_ishioda, boss_event.target

    brotherhood_event = outcome[:events].find_event("story.brotherhood_restored")
    refute_nil brotherhood_event
  end

  def test_precondition_fails_without_mabuchi_overthrow
    scene = IchibanLab::Scene.new(id: :ishioda_rematch_showdown)
    scene.add_precondition("Mabuchi debe haber sido derrocado en Qing Jin") do |ws|
      ws.flag?(:mabuchi_overthrown)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "58", flags: { mabuchi_overthrown: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_58_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "58")
    assert_equal 0, status.exitstatus, "El CLI de episodio 58 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 58_el_retorno_de_nanba"
  end
end
