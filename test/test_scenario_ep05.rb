# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep05"
require "open3"

class TestScenarioEp05 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep05.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "05_el_joven_maestro", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Entrada del club", state.location
    assert_equal 252_000, state.money
    assert state.has_item?(:masato_wallet)
    assert state.flag?(:heard_yumeno_truth)
    assert state.flag?(:club_bill_paid)
    assert state.flag?(:masato_wallet_held)
    assert state.flag?(:masato_departed)

    events = outcome[:events]
    assert events.has_event?("story.objective_started")
    assert events.has_event?("story.information_revealed")
    assert events.has_event?("story.item_acquired")
    assert events.has_event?("story.payment_made")
    assert events.has_event?("story.character_departed")
  end

  def test_precondition_escort_fails_without_summons
    scene = IchibanLab::Scene.new(id: :escorting_masato)
    scene.add_precondition("Debe haber orden de Sawashiro") { |ws| ws.flag?(:sawashiro_summons) }

    invalid_state = IchibanLab::WorldState.new(episode: "05", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_05_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "05")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 05: UNA NOCHE PARA MASATO"
    assert_includes stdout, "story.information_revealed"
  end
end
