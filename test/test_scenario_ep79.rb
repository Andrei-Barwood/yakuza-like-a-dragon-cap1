# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep79"

class TestScenarioEp79 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep79.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 79 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:resolve_to_find_aoki_formed)
    assert final_state.flag?(:survive_exterior_brawl_won)
    assert final_state.flag?(:target_hakuryo_building_set)
    assert final_state.flag?(:ep79_completed)

    realization_event = outcome[:events].find_event("story.arakawa_bloodline_realization")
    refute_nil realization_event
    assert_equal :ichiban, realization_event.actor
    assert_includes realization_event.data[:lineage], "padre_biologico"

    brawl_event = outcome[:events].find_event("story.combat_resolved")
    refute_nil brawl_event

    kume_event = outcome[:events].find_event("story.target_kume_office_set")
    refute_nil kume_event
    assert_equal "edificio_hakuryo", kume_event.data[:destination]
  end

  def test_precondition_fails_without_biological_truth
    scene = IchibanLab::Scene.new(id: :survive_bar_patrilineal_revelation)
    scene.add_precondition("La verdad biológica debe haberse revelado") do |ws|
      ws.flag?(:chapter_13_completed) && ws.flag?(:biological_truth_unveiled)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "79", flags: { chapter_13_completed: true, biological_truth_unveiled: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_79_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "79")
    assert_equal 0, status.exitstatus, "El CLI de episodio 79 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 79_la_sangre_del_patriarca"
  end
end
