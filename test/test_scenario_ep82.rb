# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep82"

class TestScenarioEp82 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep82.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 82 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:trial_condition_accepted)
    assert final_state.flag?(:kiryu_trial_fought)
    assert final_state.flag?(:geomijul_command_room_unlocked)
    assert final_state.flag?(:ep82_completed)

    choice_event = outcome[:events].find_event("story.kiryu_ultimatum_choice")
    refute_nil choice_event
    assert_equal :kazuma_kiryu, choice_event.actor
    assert_equal :ichiban, choice_event.target

    combat_event = outcome[:events].find_event("story.combat_resolved")
    refute_nil combat_event
    assert_equal :ichiban, combat_event.actor
    assert_equal :kazuma_kiryu, combat_event.target

    dream_event = outcome[:events].find_event("story.silver_dragon_dream_and_calmness")
    refute_nil dream_event
    assert_includes dream_event.data[:dream], "dragon_plateado"
  end

  def test_precondition_fails_without_ep81_completion
    scene = IchibanLab::Scene.new(id: :geomijul_courtyard_rendezvous)
    scene.add_precondition("Ep81 debe haber concluido") do |ws|
      ws.flag?(:ep81_completed) && ws.flag?(:geomijul_meeting_scheduled)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "82", flags: { ep81_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_82_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "82")
    assert_equal 0, status.exitstatus, "El CLI de episodio 82 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 82_la_prueba_del_dragon"
  end
end
