# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep69"

class TestScenarioEp69 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep69.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 69 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:majima_saejima_defeated)
    assert final_state.flag?(:tojo_legends_alliance_confirmed)
    assert_equal "Cuartel General Omi - Cámara del Dragón", final_state.location

    guards_event = outcome[:events].find_event("story.omi_hall_guards_defeated")
    refute_nil guards_event
    assert_equal :ichiban, guards_event.actor

    majima_event = outcome[:events].find_event("story.legendary_trial_combat_started")
    refute_nil majima_event
    assert_equal :goro_majima, majima_event.actor
    assert_equal "el_perro_rabioso_de_shimano", majima_event.data[:opponent]

    daigo_event = outcome[:events].find_event("story.daigo_and_arakawa_revealed_allies")
    refute_nil daigo_event
    assert_equal :masumi_arakawa, daigo_event.actor
    assert_equal "daigo_dojima", daigo_event.data[:sixth_chairman]
  end

  def test_precondition_fails_without_catering_disguise
    scene = IchibanLab::Scene.new(id: :corridor_guards_skirmish)
    scene.add_precondition("El grupo debe haber penetrado disfrazado") do |ws|
      ws.flag?(:catering_disguise_ready)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "69", flags: { catering_disguise_ready: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_69_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "69")
    assert_equal 0, status.exitstatus, "El CLI de episodio 69 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 69_los_dragones_legendarios"
  end
end
