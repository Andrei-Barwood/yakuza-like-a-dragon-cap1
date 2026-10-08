# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep77"

class TestScenarioEp77 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep77.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 77 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:jinnai_perimeter_reached)
    assert final_state.flag?(:public_handshake_completed)
    assert final_state.flag?(:seiryu_assault_alert_active)
    assert final_state.flag?(:ep77_completed)

    foot_event = outcome[:events].find_event("story.jinnai_foot_patrol_approach")
    refute_nil foot_event
    assert_equal :ichiban, foot_event.actor

    handshake_event = outcome[:events].find_event("story.forced_election_handshake")
    refute_nil handshake_event
    assert_equal :ichiban, handshake_event.actor
    assert_equal :sota_kume, handshake_event.target

    alert_event = outcome[:events].find_event("story.geomijul_alert_hoshino_targeted")
    refute_nil alert_event
    assert_equal :joon_gi_han, alert_event.actor
    assert_equal :ichiban, alert_event.target
  end

  def test_precondition_fails_without_ep76_completion
    scene = IchibanLab::Scene.new(id: :jinnai_station_approach_on_foot)
    scene.add_precondition("El episodio 76 debe haber finalizado con ultimátum") do |ws|
      ws.flag?(:ep76_completed) && ws.flag?(:sawashiro_ultimatum_issued)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "77", flags: { ep76_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_77_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "77")
    assert_equal 0, status.exitstatus, "El CLI de episodio 77 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 77_el_apreton_de_manos_en_jinnai"
  end
end
