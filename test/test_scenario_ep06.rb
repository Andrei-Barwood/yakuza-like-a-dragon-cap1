# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep06"
require "open3"

class TestScenarioEp06 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep06.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "06_lo_que_nos_une", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Apartamento de Ichiban", state.location
    assert_equal "2000 - Fin de la noche", state.time_period
    assert_equal 2000, state.money
    refute state.has_item?(:masato_wallet)
    assert state.flag?(:funds_deposited)
    assert state.flag?(:masato_wallet_returned)
    assert state.flag?(:arakawa_intervened)
    assert state.flag?(:shared_past_revealed)
    assert state.flag?(:theater_square_cleared)
    assert state.flag?(:resting_for_night)

    ichiban = state.character(:ichiban)
    assert_equal :father_figure, ichiban.relationship(:arakawa)

    arakawa = state.character(:arakawa)
    assert_equal :surrogate_son, arakawa.relationship(:ichiban)

    events = outcome[:events]
    assert events.has_event?("story.item_returned")
    assert events.has_event?("story.funds_deposited")
    assert events.has_event?("story.conflict_defused")
    assert events.has_event?("story.bond_deepened")
    assert events.has_event?("story.combat_resolved")
  end

  def test_precondition_office_fails_without_masato_wallet
    scene = IchibanLab::Scene.new(id: :office_reprimand)
    scene.add_precondition("Ichiban debe portar la cartera") { |ws| ws.flag?(:masato_wallet_held) }

    invalid_state = IchibanLab::WorldState.new(episode: "06", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_06_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "06")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 06: LA FAMILIA ARAKAWA"
    assert_includes stdout, "story.bond_deepened"
  end
end
