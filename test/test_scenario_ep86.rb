# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep86"

class TestScenarioEp86 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep86.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 86 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:millennium_atrium_cleared)
    assert final_state.flag?(:penthouse_reached)
    assert final_state.flag?(:tendo_defeated)
    assert final_state.flag?(:ep86_completed)

    election_event = outcome[:events].find_event("story.election_results_broadcast")
    refute_nil election_event
    assert_equal :ichiban, election_event.actor

    nick_event = outcome[:events].find_event("story.nick_intel_live_transmission")
    refute_nil nick_event
    assert_equal :nick_ogata, nick_event.actor

    tendo_event = outcome[:events].find_event("story.tendo_confrontation_and_motive")
    refute_nil tendo_event
    assert_equal :yosuke_tendo, tendo_event.actor
    assert_includes tendo_event.data[:confession], "ejecutado_a_masumi_arakawa"

    vanquished_event = outcome[:events].find_event("story.tendo_vanquished")
    refute_nil vanquished_event
    assert_equal :ichiban, vanquished_event.actor
  end

  def test_precondition_fails_without_ep85_completion
    scene = IchibanLab::Scene.new(id: :millennium_tower_breach)
    scene.add_precondition("El episodio 85 debe haberse completado") do |ws|
      ws.flag?(:ep85_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "86", flags: { ep85_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_86_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "86")
    assert_equal 0, status.exitstatus, "El CLI de episodio 86 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 86: LA CUMBRE DE LA TORRE MILENIO"
  end
end
