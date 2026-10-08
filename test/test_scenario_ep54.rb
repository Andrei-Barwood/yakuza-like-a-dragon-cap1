# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep54"

class TestScenarioEp54 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep54.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 54 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:omi_raid_repelled)
    assert final_state.flag?(:shoichi_confirmed_alive)
    assert final_state.flag?(:chapter_9_completed)
    assert_equal "Campamento de Indigentes - Orilla del Río", final_state.location

    fire_event = outcome[:events].find_event("story.fire_noticed")
    refute_nil fire_event
    assert_equal :hajime_ogasawara, fire_event.actor

    clash_event = outcome[:events].find_event("story.epic_clash_resolved")
    refute_nil clash_event
    assert_equal true, clash_event.data[:victory]

    capture_event = outcome[:events].find_event("story.ogasawara_captured")
    refute_nil capture_event
    assert_equal :joon_gi_han, capture_event.actor

    brother_event = outcome[:events].find_event("story.brother_safety_revealed")
    refute_nil brother_event
    assert_equal :seonhee, brother_event.actor

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 9, boundary_event.data[:chapter]
    assert_equal :chapter_10, boundary_event.data[:next]
  end

  def test_precondition_fails_without_scorched_earth_active
    scene = IchibanLab::Scene.new(id: :printer_room_confrontation)
    scene.add_precondition("El plan de quema y retención de Geomijul debe estar activo") do |ws|
      ws.flag?(:geomijul_scorched_earth_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "54", flags: { geomijul_scorched_earth_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_54_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "54")
    assert_equal 0, status.exitstatus, "El CLI de episodio 54 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 54_el_sacrificio_de_geomijul"
  end
end
