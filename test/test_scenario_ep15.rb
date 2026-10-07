# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep15"

class TestScenarioEp15 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep15.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 15 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:counterfeit_bill_revealed)
    assert final_state.flag?(:liumang_clash_witnessed)
    assert final_state.has_item?(:counterfeit_10k_bill)
    assert_equal 1300, final_state.money
  end

  def test_precondition_cans_fails_without_camp_permission
    scene = IchibanLab::Scene.new(id: :can_collection_dawn)
    scene.add_precondition("Ichiban debe tener permiso del campamento") { |ws| ws.flag?(:camp_stay_permitted) }

    invalid_state = IchibanLab::WorldState.new(episode: "15", flags: { camp_stay_permitted: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_15_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "15")
    assert_equal 0, status.exitstatus, "El CLI de episodio 15 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 15_la_ley_del_campamento"
  end
end
