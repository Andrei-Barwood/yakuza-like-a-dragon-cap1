# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep38"

class TestScenarioEp38 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep38.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 38 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:han_identity_confirmed)
    assert final_state.flag?(:mabuchi_murder_footage_confirmed)
    assert outcome[:events].has_event?("story.electrical_network_traversal")
    assert outcome[:events].has_event?("story.identity_revealed")
    assert outcome[:events].has_event?("story.incriminating_footage_viewed")
  end

  def test_precondition_cables_fails_without_geomijul_entrance
    scene = IchibanLab::Scene.new(id: :cable_crossing_and_ambush)
    scene.add_precondition("El grupo debe haber ingresado al edificio de Geomijul") { |ws| ws.flag?(:geomijul_entrance_reached) }

    invalid_state = IchibanLab::WorldState.new(episode: "38", flags: { geomijul_entrance_reached: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_38_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "38")
    assert_equal 0, status.exitstatus, "El CLI de episodio 38 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 38_la_fortaleza_electrica"
  end
end
