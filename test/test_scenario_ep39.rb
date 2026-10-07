# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep39"

class TestScenarioEp39 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep39.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 39 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:seonhee_identified)
    assert final_state.flag?(:nanba_suspicions_triggered)
    assert outcome[:events].has_event?("story.secret_mint_unveiled")
    assert outcome[:events].has_event?("story.leader_identity_revealed")
    assert outcome[:events].has_event?("story.gunpoint_cross_examination")
  end

  def test_precondition_mint_fails_without_mabuchi_footage
    scene = IchibanLab::Scene.new(id: :counterfeit_yen_factory)
    scene.add_precondition("Las cintas de Mabuchi deben haber sido revisadas") { |ws| ws.flag?(:mabuchi_murder_footage_confirmed) }

    invalid_state = IchibanLab::WorldState.new(episode: "39", flags: { mabuchi_murder_footage_confirmed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_39_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "39")
    assert_equal 0, status.exitstatus, "El CLI de episodio 39 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 39_la_reina_de_la_telaraña"
  end
end
