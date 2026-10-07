# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep36"

class TestScenarioEp36 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep36.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 36 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:geomijul_lead_unlocked)
    assert final_state.flag?(:temporary_ceasefire_active)
    assert final_state.flag?(:chapter_6_completed)

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 6, boundary_event.data[:chapter]
    assert_equal :chapter_7, boundary_event.data[:next]
  end

  def test_precondition_zhao_fails_without_takabe_subdued
    scene = IchibanLab::Scene.new(id: :zhao_arrival_outside_qing_jin)
    scene.add_precondition("Takabe debe haber sido reducido") { |ws| ws.flag?(:takabe_subdued) }

    invalid_state = IchibanLab::WorldState.new(episode: "36", flags: { takabe_subdued: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_36_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "36")
    assert_equal 0, status.exitstatus, "El CLI de episodio 36 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 36_el_juicio_de_tianyou_zhao"
  end
end
