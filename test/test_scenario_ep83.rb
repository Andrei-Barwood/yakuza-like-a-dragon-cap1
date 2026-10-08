# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep83"

class TestScenarioEp83 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep83.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 83 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:mirror_face_identified)
    assert final_state.flag?(:kiryu_boundaries_explained)
    assert final_state.flag?(:bar_district_target_confirmed)
    assert final_state.flag?(:ep83_completed)

    footage_event = outcome[:events].find_event("story.mirror_face_footage_discovered")
    refute_nil footage_event
    assert_equal :tianyou_zhao, footage_event.actor
    assert_includes footage_event.data[:hitman], "mirror_face"

    erasure_event = outcome[:events].find_event("story.kiryu_contract_of_erasure")
    refute_nil erasure_event
    assert_equal :kazuma_kiryu, erasure_event.actor
    assert_includes erasure_event.data[:reason], "orfanato_de_okinawa"

    hideout_event = outcome[:events].find_event("story.ishioda_hideout_pinpointed")
    refute_nil hideout_event
    assert_equal :seonhee, hideout_event.actor
    assert_includes hideout_event.data[:reinforcements], "4to_piso"
  end

  def test_precondition_fails_without_ep82_completion
    scene = IchibanLab::Scene.new(id: :geomijul_surveillance_monitor_room)
    scene.add_precondition("La sala de mandos de Geomijul debe estar desbloqueada") do |ws|
      ws.flag?(:ep82_completed) && ws.flag?(:geomijul_command_room_unlocked)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "83", flags: { ep82_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_83_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "83")
    assert_equal 0, status.exitstatus, "El CLI de episodio 83 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 83_el_asesino_del_espejo"
  end
end
