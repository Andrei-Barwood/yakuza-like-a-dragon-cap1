# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep32"

class TestScenarioEp32 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep32.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 32 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:ichiban_unshackled)
    assert final_state.flag?(:party_freed)
    refute final_state.flag?(:party_restrained)
    assert final_state.flag?(:gear_recovered)
    assert final_state.has_item?(:counterfeit_yuan_sample)
    assert outcome[:events].has_event?("story.mysterious_ally_intervention")
  end

  def test_precondition_rescue_fails_without_execution_order
    scene = IchibanLab::Scene.new(id: :mysterious_savior_rescue)
    scene.add_precondition("La ejecución debe haber sido ordenada") { |ws| ws.flag?(:execution_ordered) }

    invalid_state = IchibanLab::WorldState.new(episode: "32", flags: { execution_ordered: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_32_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "32")
    assert_equal 0, status.exitstatus, "El CLI de episodio 32 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 32_la_fuga_subterranea"
  end
end
