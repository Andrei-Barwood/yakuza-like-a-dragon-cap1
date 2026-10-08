# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep75"

class TestScenarioEp75 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep75.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 75 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:kume_security_skirmish_won)
    assert final_state.flag?(:deposit_money_received)
    assert final_state.flag?(:kasuga_candidacy_active)
    assert final_state.flag?(:ep75_completed)
    assert_equal 26300, final_state.money # Recibe 3M y los gasta en el depósito

    blockade_event = outcome[:events].find_event("story.kume_rally_omi_blockade")
    refute_nil blockade_event
    assert_equal :ichiban, blockade_event.actor
    assert_equal :sota_kume, blockade_event.target

    strategy_event = outcome[:events].find_event("story.election_run_proposed")
    refute_nil strategy_event
    assert_equal :ryuhei_hoshino, strategy_event.actor
    assert_equal :ichiban, strategy_event.target

    registration_event = outcome[:events].find_event("story.candidacy_officially_registered")
    refute_nil registration_event
    assert_equal :ichiban, registration_event.actor
    assert_equal "Kanagawa 2nd District", registration_event.data[:district]
  end

  def test_precondition_fails_without_ep74_completion
    scene = IchibanLab::Scene.new(id: :isezaki_road_kume_speech_confrontation)
    scene.add_precondition("El episodio 74 debe haber finalizado") do |ws|
      ws.flag?(:ep74_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "75", flags: { ep74_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_75_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "75")
    assert_equal 0, status.exitstatus, "El CLI de episodio 75 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 75_la_candidatura_inesperada"
  end
end
