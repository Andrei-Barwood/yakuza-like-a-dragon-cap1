# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep55"

class TestScenarioEp55 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep55.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 55 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ogasawara_interrogated)
    assert final_state.flag?(:zhao_rescue_mission_active)
    assert final_state.flag?(:nanba_departed_temporarily)
    assert_equal 26300, final_state.money

    interrogation_event = outcome[:events].find_event("story.captive_interrogated")
    refute_nil interrogation_event
    assert_equal :ichiban, interrogation_event.actor
    assert_equal :hajime_ogasawara, interrogation_event.target

    rescue_event = outcome[:events].find_event("story.zhao_distress_recalled")
    refute_nil rescue_event

    safety_event = outcome[:events].find_event("story.brother_safety_confirmed")
    refute_nil safety_event
    assert_equal :nanba, safety_event.actor
  end

  def test_precondition_fails_without_chapter_9_completion
    scene = IchibanLab::Scene.new(id: :homeless_camp_interrogation)
    scene.add_precondition("Ogasawara debe estar en custodia y Shoichi a salvo tras el Capítulo 9") do |ws|
      ws.flag?(:chapter_9_completed) && ws.flag?(:shoichi_confirmed_alive)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "55", flags: { chapter_9_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_55_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "55")
    assert_equal 0, status.exitstatus, "El CLI de episodio 55 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 55_el_interrogatorio_de_ogasawara"
  end
end
