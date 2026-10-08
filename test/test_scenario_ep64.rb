# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep64"

class TestScenarioEp64 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep64.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 64 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:otohime_meeting_scheduled)
    assert_equal "Aparcamiento Subterráneo Ribereño", final_state.location

    elevator_event = outcome[:events].find_event("story.hidden_elevator_found")
    refute_nil elevator_event
    assert_equal :adachi, elevator_event.actor

    unmasked_event = outcome[:events].find_event("story.omi_escorts_unmasked")
    refute_nil unmasked_event
    assert_equal "kansai_ben", unmasked_event.data[:dialect]

    disarm_event = outcome[:events].find_event("story.adachi_disarm_and_combat")
    refute_nil disarm_event
    assert_equal "guardias_sometidos", disarm_event.data[:outcome]

    summons_event = outcome[:events].find_event("story.aoki_private_summons_issued")
    refute_nil summons_event
    assert_equal "Otohime Land", summons_event.data[:meeting_place]
  end

  def test_precondition_fails_without_underground_parking_target
    scene = IchibanLab::Scene.new(id: :hidden_elevator_search)
    scene.add_precondition("El grupo debe buscar la ruta subterránea") do |ws|
      ws.flag?(:underground_parking_target_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "64", flags: { underground_parking_target_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_64_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "64")
    assert_equal 0, status.exitstatus, "El CLI de episodio 64 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 64_el_estacionamiento_subterraneo"
  end
end
