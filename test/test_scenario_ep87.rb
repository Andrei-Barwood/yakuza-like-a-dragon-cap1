# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep87"

class TestScenarioEp87 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep87.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 87 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:aoki_fled_clp_hq)
    assert final_state.flag?(:mirror_face_impersonation_triggered)
    assert final_state.flag?(:aoki_publicly_exposed)
    assert final_state.flag?(:ep87_completed)

    clp_event = outcome[:events].find_event("story.clp_victory_celebration_disrupted")
    refute_nil clp_event
    assert_equal :ryo_aoki, clp_event.actor
    assert_includes clp_event.data[:nick_outcry], "masato_arakawa"

    ambush_event = outcome[:events].find_event("story.aoki_arrival_at_penthouse")
    refute_nil ambush_event
    assert_equal :ryo_aoki, ambush_event.actor
    assert_equal :mirror_face, ambush_event.target

    twist_event = outcome[:events].find_event("story.mirror_face_unmasked")
    refute_nil twist_event
    assert_equal :mirror_face, twist_event.actor
    assert_equal :ryo_aoki, twist_event.target

    broadcast_event = outcome[:events].find_event("story.hidden_cameras_live_stream")
    refute_nil broadcast_event
    assert_equal :joon_gi_han, broadcast_event.actor
    assert_equal :ryo_aoki, broadcast_event.target
  end

  def test_precondition_fails_without_tendo_defeated
    scene = IchibanLab::Scene.new(id: :election_night_headquarters)
    scene.add_precondition("Tendo debe estar derrotado en el episodio 86") do |ws|
      ws.flag?(:ep86_completed) && ws.flag?(:tendo_defeated)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "87", flags: { ep86_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_87_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "87")
    assert_equal 0, status.exitstatus, "El CLI de episodio 87 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 87: LA TRAMPA DEL CAMALEÓN"
  end
end
