# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep80"

class TestScenarioEp80 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep80.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 80 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:hakuryo_omi_thugs_defeated)
    assert final_state.flag?(:kiryu_intervened_rage_halted)
    assert final_state.flag?(:geomijul_meeting_scheduled)
    assert final_state.flag?(:ep80_completed)

    deserted_event = outcome[:events].find_event("story.hakuryo_office_deserted")
    refute_nil deserted_event

    thug_event = outcome[:events].find_event("story.thug_confesses_kume_flight")
    refute_nil thug_event
    assert_includes thug_event.data[:intel], "kamurocho"

    halt_event = outcome[:events].find_event("story.kiryu_stops_ichiban_rage")
    refute_nil halt_event
    assert_equal :kazuma_kiryu, halt_event.actor
    assert_equal :ichiban, halt_event.target

    summons_event = outcome[:events].find_event("story.kiryu_geomijul_summons")
    refute_nil summons_event
    assert_includes summons_event.data[:warning], "ijincho"
  end

  def test_precondition_fails_without_ep79_completion
    scene = IchibanLab::Scene.new(id: :hakuryo_building_empty_office)
    scene.add_precondition("El objetivo de Hakuryo debe estar fijado") do |ws|
      ws.flag?(:ep79_completed) && ws.flag?(:target_hakuryo_building_set)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "80", flags: { ep79_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_80_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "80")
    assert_equal 0, status.exitstatus, "El CLI de episodio 80 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 80_la_aparicion_del_dragon"
  end
end
