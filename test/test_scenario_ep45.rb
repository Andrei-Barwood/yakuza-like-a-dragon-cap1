# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep45"

class TestScenarioEp45 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep45.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 45 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:hakuryo_entrance_cleared)
    assert final_state.flag?(:bleach_japan_office_reached)
    assert_equal "Edificio Hakuryo - Planta 2F", final_state.location

    clash_event = outcome[:events].find_event("story.traitor_confrontation")
    refute_nil clash_event
    assert_equal :renegade_geomijul, clash_event.actor

    combat_event = outcome[:events].find_event("story.combat_resolved")
    refute_nil combat_event
    assert_equal true, combat_event.data[:victory]
  end

  def test_precondition_fails_without_hakuryo_target_active
    scene = IchibanLab::Scene.new(id: :hakuryo_building_perimeter)
    scene.add_precondition("El objetivo del Edificio Hakuryo debe estar activo") do |ws|
      ws.flag?(:hakuryo_building_target_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "45", flags: { hakuryo_building_target_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_45_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "45")
    assert_equal 0, status.exitstatus, "El CLI de episodio 45 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 45_asalto_al_edificio_hakuryo"
  end
end
