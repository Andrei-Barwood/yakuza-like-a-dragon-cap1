# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep48"

class TestScenarioEp48 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep48.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 48 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:masato_arakawa_identity_revealed)
    assert final_state.flag?(:chapter_8_completed)
    assert_equal "Oficina del Gobernador de Tokio - Shinjuku", final_state.location

    epiphany_event = outcome[:events].find_event("story.identity_epiphany")
    refute_nil epiphany_event
    assert_equal :ichiban, epiphany_event.actor
    assert_includes epiphany_event.data[:real_identity], "Masato Arakawa"

    call_event = outcome[:events].find_event("story.secret_call_received")
    refute_nil call_event
    assert_equal :ryo_aoki, call_event.actor

    invasion_event = outcome[:events].find_event("story.invasion_forces_ordered")
    refute_nil invasion_event
    assert_equal :ryo_aoki, invasion_event.actor

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 8, boundary_event.data[:chapter]
    assert_equal :chapter_9, boundary_event.data[:next]
  end

  def test_precondition_fails_without_founders_clipping
    scene = IchibanLab::Scene.new(id: :photo_scrutiny_and_shocking_truth)
    scene.add_precondition("El recorte de prensa debe estar en posesión del grupo") do |ws|
      ws.flag?(:founders_clipping_found)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "48", flags: { founders_clipping_found: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_48_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "48")
    assert_equal 0, status.exitstatus, "El CLI de episodio 48 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 48_la_verdadera_identidad_de_aoki"
  end
end
