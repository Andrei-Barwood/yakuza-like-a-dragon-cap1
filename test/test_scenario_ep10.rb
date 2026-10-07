# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep10"
require "open3"

class TestScenarioEp10 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep10.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "10_rescate_en_la_calle", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Frente a la reja de alcantarillado", state.location
    assert state.has_item?(:nick_ogata_business_card)
    assert state.flag?(:nick_ogata_rescued)
    assert state.flag?(:extortionists_defeated)
    assert state.flag?(:adachi_party_joined)
    assert_equal :enter_underground_sewers, state.flag(:next_step)

    ichiban = state.character(:ichiban)
    assert_equal :partner, ichiban.relationship(:adachi)

    events = outcome[:events]
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.item_acquired")
    assert events.has_event?("story.party_member_joined")
    assert events.has_event?("story.objective_started")
  end

  def test_precondition_cry_fails_without_summit_objective
    scene = IchibanLab::Scene.new(id: :pink_street_alley_cry)
    scene.add_precondition("Debe haber una búsqueda activa de acceso") do |ws|
      ws.flag(:next_objective) == :find_way_into_summit
    end

    invalid_state = IchibanLab::WorldState.new(episode: "10", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_10_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "10")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 10: ALIANZA CON ADACHI Y NICK OGATA"
    assert_includes stdout, "story.party_member_joined"
  end
end
