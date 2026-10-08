# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep56"

class TestScenarioEp56 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep56.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 56 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:han_joined_party)
    assert final_state.flag?(:qing_jin_infiltrated)
    assert_equal "Restaurante Qing Jin - Planta Baja", final_state.location

    reinforcement_event = outcome[:events].find_event("story.party_reinforcement_joined")
    refute_nil reinforcement_event
    assert_equal :joon_gi_han, reinforcement_event.actor

    bounty_event = outcome[:events].find_event("story.bounty_announced")
    refute_nil bounty_event
    assert_equal 100_000_000, bounty_event.data[:bounty]

    combat_event = outcome[:events].find_event("story.combat_resolved")
    refute_nil combat_event
    assert_equal true, combat_event.data[:victory]
  end

  def test_precondition_fails_without_zhao_rescue_active
    scene = IchibanLab::Scene.new(id: :geomijul_reinforcement_delegation)
    scene.add_precondition("La misión de rescate de Zhao debe estar activa") do |ws|
      ws.flag?(:zhao_rescue_mission_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "56", flags: { zhao_rescue_mission_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_56_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "56")
    assert_equal 0, status.exitstatus, "El CLI de episodio 56 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 56_el_rescate_de_zhao"
  end
end
