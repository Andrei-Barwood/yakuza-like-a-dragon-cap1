# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep66"

class TestScenarioEp66 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep66.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 66 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:hamako_workers_deported)
    assert final_state.flag?(:war_against_aoki_declared)
    assert final_state.flag?(:chapter_11_completed)
    assert_equal "Calles de Ijincho - Frente a Otohime Land", final_state.location

    ambush_event = outcome[:events].find_event("story.omi_execution_ambush_sprung")
    refute_nil ambush_event
    assert_equal :jo_sawashiro, ambush_event.actor

    nanba_event = outcome[:events].find_event("story.nanba_opportune_intervention")
    refute_nil nanba_event
    assert_equal :nanba, nanba_event.actor

    combat_event = outcome[:events].find_event("story.omi_enforcers_defeated")
    refute_nil combat_event
    assert_equal :ichiban, combat_event.actor

    deportation_event = outcome[:events].find_event("story.migrant_women_deportation_confirmed")
    refute_nil deportation_event
    assert_equal :hamako, deportation_event.actor

    resolve_event = outcome[:events].find_event("story.no_turning_back_resolved")
    refute_nil resolve_event
    assert_includes resolve_event.data[:resolution], "guerra_total_contra_aoki"

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 11, boundary_event.data[:chapter]
    assert_equal :chapter_12, boundary_event.data[:next]
  end

  def test_precondition_fails_without_broken_talks
    scene = IchibanLab::Scene.new(id: :otohime_ambush_and_nanba_rescue)
    scene.add_precondition("Las negociaciones con Aoki deben haberse roto") do |ws|
      ws.flag?(:aoki_talks_broken)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "66", flags: { aoki_talks_broken: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_66_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "66")
    assert_equal 0, status.exitstatus, "El CLI de episodio 66 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 66_el_desengano_y_la_resolucion"
  end
end
