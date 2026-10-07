# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep43"

class TestScenarioEp43 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep43.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 43 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ogikubo_system_fully_understood)
    assert_equal 26300, final_state.money

    postwar_event = outcome[:events].find_event("story.postwar_origin_revealed")
    refute_nil postwar_event
    assert_equal :ryuhei_hoshino, postwar_event.actor
    assert_equal "Yutaka Ogikubo", postwar_event.data[:originator]

    jingweon_event = outcome[:events].find_event("story.jingweon_integration_recounted")
    refute_nil jingweon_event
    assert_equal :seonhee, jingweon_event.actor
  end

  def test_precondition_fails_without_chapter_7_completion
    scene = IchibanLab::Scene.new(id: :heian_tower_triumvirate_dialogue)
    scene.add_precondition("El grupo debe proceder de la cumbre del Capítulo 7") do |ws|
      ws.flag?(:chapter_7_completed) && ws.flag?(:ijin_three_summit_concluded)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "43", flags: { chapter_7_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_43_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "43")
    assert_equal 0, status.exitstatus, "El CLI de episodio 43 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 43_el_pacto_de_los_tres"
  end
end
