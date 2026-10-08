# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep88"

class TestScenarioEp88 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep88.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 88 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:aoki_bodyguards_defeated)
    assert final_state.flag?(:aoki_duel_won)
    assert final_state.flag?(:aoki_escaped_to_streets)
    assert final_state.flag?(:ep88_completed)

    clash_event = outcome[:events].find_event("story.aoki_bodyguards_clash")
    refute_nil clash_event
    assert_equal :ryo_aoki, clash_event.actor

    duel_event = outcome[:events].find_event("story.ideological_clash_of_brothers")
    refute_nil duel_event
    assert_equal :ichiban, duel_event.actor
    assert_equal :ryo_aoki, duel_event.target

    hostage_event = outcome[:events].find_event("story.police_arrival_and_hostage_crisis")
    refute_nil hostage_event
    assert_equal :ryo_aoki, hostage_event.actor

    escape_event = outcome[:events].find_event("story.elevator_escape_and_final_words")
    refute_nil escape_event
    assert_equal :ryo_aoki, escape_event.actor
  end

  def test_precondition_fails_without_ep87_completion
    scene = IchibanLab::Scene.new(id: :aoki_bodyguards_brawl)
    scene.add_precondition("Aoki debe haber sido expuesto públicamente") do |ws|
      ws.flag?(:ep87_completed) && ws.flag?(:aoki_publicly_exposed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "88", flags: { ep87_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_88_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "88")
    assert_equal 0, status.exitstatus, "El CLI de episodio 88 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 88: EL FIN DEL ADVENEDIZO"
  end
end
