# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep49"

class TestScenarioEp49 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep49.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 49 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:aoki_background_uncovered)
    assert final_state.flag?(:survive_hideout_unlocked)
    assert_equal "Survive Bar - Planta 2F", final_state.location
    assert_equal 26300, final_state.money

    profile_event = outcome[:events].find_event("story.profile_scrutiny")
    refute_nil profile_event
    assert_equal :ichiban, profile_event.actor

    plan_event = outcome[:events].find_event("story.kamurocho_3k_plan_analyzed")
    refute_nil plan_event
    assert_equal :adachi, plan_event.actor

    register_event = outcome[:events].find_event("story.family_register_theft_deduced")
    refute_nil register_event
  end

  def test_precondition_fails_without_chapter_8_completion
    scene = IchibanLab::Scene.new(id: :survive_bar_aoki_profile_analysis)
    scene.add_precondition("El grupo debe poseer el recorte de los fundadores del Capítulo 8") do |ws|
      ws.flag?(:chapter_8_completed) && ws.has_item?(:bleach_japan_founders_clipping)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "49", flags: { chapter_8_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_49_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "49")
    assert_equal 0, status.exitstatus, "El CLI de episodio 49 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 49_el_perfil_de_aoki"
  end
end
