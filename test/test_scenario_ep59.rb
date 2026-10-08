# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep59"

class TestScenarioEp59 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep59.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 59 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:mitsuo_intel_received)
    assert final_state.flag?(:liumang_geomijul_alliance_sealed)
    assert_equal "Restaurant Row - Exterior de Qing Jin", final_state.location

    friend_event = outcome[:events].find_event("story.old_friend_revealed")
    refute_nil friend_event
    assert_equal "Mitsuo Yasuda", friend_event.data[:companion]

    move_event = outcome[:events].find_event("story.arakawa_upcoming_move_revealed")
    refute_nil move_event
    assert_equal :mitsuo_yasuda, move_event.actor

    transition_event = outcome[:events].find_event("story.zhao_leadership_transition")
    refute_nil transition_event
    assert_equal :tianyou_zhao, transition_event.actor
  end

  def test_precondition_fails_without_nanba_rejoin
    scene = IchibanLab::Scene.new(id: :zhao_liberation_and_mitsuo_meeting)
    scene.add_precondition("Nanba debe haberse reunido con el grupo tras derrotar a Ishioda") do |ws|
      ws.flag?(:nanba_permanently_rejoined) && ws.flag?(:ishioda_subdued)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "59", flags: { nanba_permanently_rejoined: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_59_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "59")
    assert_equal 0, status.exitstatus, "El CLI de episodio 59 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 59_reencuentro_con_mitsuo"
  end
end
