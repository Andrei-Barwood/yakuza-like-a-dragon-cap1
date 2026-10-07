# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep42"

class TestScenarioEp42 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep42.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 42 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ogikubo_conspiracy_revealed)
    assert final_state.flag?(:ijin_three_summit_concluded)
    assert final_state.flag?(:chapter_7_completed)
    assert final_state.has_item?(:shoichi_investigative_notes)

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 7, boundary_event.data[:chapter]
    assert_equal :chapter_8, boundary_event.data[:next]
  end

  def test_precondition_laptop_fails_without_heian_summons
    scene = IchibanLab::Scene.new(id: :nanba_laptop_investigation)
    scene.add_precondition("La cita de Heian Tower debe estar activa") { |ws| ws.flag?(:heian_tower_summons_active) }

    invalid_state = IchibanLab::WorldState.new(episode: "42", flags: { heian_tower_summons_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_42_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "42")
    assert_equal 0, status.exitstatus, "El CLI de episodio 42 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 42_la_cumbre_de_los_tres"
  end
end
