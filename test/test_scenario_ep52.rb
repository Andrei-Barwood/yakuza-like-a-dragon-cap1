# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep52"

class TestScenarioEp52 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep52.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 52 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ishioda_crane_repelled)
    assert final_state.flag?(:geomijul_perimeter_breached)
    assert_equal "Koreatown - Callejón Trasero", final_state.location

    crane_event = outcome[:events].find_event("story.crane_operator_revealed")
    refute_nil crane_event
    assert_equal :reiji_ishioda, crane_event.actor

    boss_event = outcome[:events].find_event("story.wrecking_ball_boss_battle")
    refute_nil boss_event
    assert_equal true, boss_event.data[:victory]

    lieutenants_event = outcome[:events].find_event("story.three_lieutenants_briefing")
    refute_nil lieutenants_event
    assert_includes lieutenants_event.data[:lieutenants], "Reiji Ishioda"
  end

  def test_precondition_fails_without_kume_vanguard_dispersed
    scene = IchibanLab::Scene.new(id: :wrecking_ball_arrival)
    scene.add_precondition("La vanguardia de Kume debe haber sido dispersada") do |ws|
      ws.flag?(:kume_vanguard_dispersed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "52", flags: { kume_vanguard_dispersed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_52_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "52")
    assert_equal 0, status.exitstatus, "El CLI de episodio 52 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 52_la_bola_de_demolicion"
  end
end
