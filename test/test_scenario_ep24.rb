# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep24"

class TestScenarioEp24 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep24.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 24 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.has_item?(:seiryu_clan_key)
    assert final_state.flag?(:hoshino_respected_ichiban)
    assert final_state.flag?(:nonomiya_found_dead)
    assert final_state.flag?(:chapter_4_completed)
    assert_equal 26300, final_state.money

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 4, boundary_event.data[:chapter]
    assert_equal :concluded, boundary_event.data[:status]
    assert_equal :chapter_5, boundary_event.data[:next]
  end

  def test_precondition_infil_fails_without_totsuka_escort
    scene = IchibanLab::Scene.new(id: :seiryu_headquarters_infiltration)
    scene.add_precondition("Tatsuro debe haber sido rescatado y Totsuka llevado al clan") { |ws| ws.flag?(:escorting_totsuka_to_seiryu) }

    invalid_state = IchibanLab::WorldState.new(episode: "24", flags: { escorting_totsuka_to_seiryu: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_24_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "24")
    assert_equal 0, status.exitstatus, "El CLI de episodio 24 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 24_el_dragon_del_seiryu"
  end
end
