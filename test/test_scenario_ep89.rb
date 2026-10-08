# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep89"

class TestScenarioEp89 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep89.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 89 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:coin_lockers_reached)
    assert final_state.flag?(:aoki_surrender_pledged)
    assert final_state.flag?(:aoki_fatally_stabbed)
    assert final_state.flag?(:ep89_completed)

    wander_event = outcome[:events].find_event("story.aoki_wander_in_ruins")
    refute_nil wander_event
    assert_equal :ryo_aoki, wander_event.actor

    suicide_event = outcome[:events].find_event("story.aoki_suicide_attempt")
    refute_nil suicide_event
    assert_equal :ryo_aoki, suicide_event.actor
    assert_equal :ichiban, suicide_event.target

    plea_event = outcome[:events].find_event("story.kasuga_tearful_plea_brotherhood")
    refute_nil plea_event
    assert_equal :ichiban, plea_event.actor
    assert_equal :ryo_aoki, plea_event.target

    relents_event = outcome[:events].find_event("story.aoki_relents_and_surrenders_gun")
    refute_nil relents_event
    assert_equal :ryo_aoki, relents_event.actor

    kume_event = outcome[:events].find_event("story.kume_fanatical_assassination")
    refute_nil kume_event
    assert_equal :sota_kume, kume_event.actor
    assert_equal :ryo_aoki, kume_event.target

    despair_event = outcome[:events].find_event("story.kasuga_desperate_embrace")
    refute_nil despair_event
    assert_equal :ichiban, despair_event.actor
  end

  def test_precondition_fails_without_ep88_completion
    scene = IchibanLab::Scene.new(id: :kamurocho_streets_pursuit)
    scene.add_precondition("Aoki debe haber escapado a las calles en el episodio 88") do |ws|
      ws.flag?(:ep88_completed) && ws.flag?(:aoki_escaped_to_streets)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "89", flags: { ep88_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_89_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "89")
    assert_equal 0, status.exitstatus, "El CLI de episodio 89 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 89: LAS TAQUILLAS DEL DESTINO"
  end
end
