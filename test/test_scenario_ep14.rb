# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep14"

class TestScenarioEp14 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep14.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 14 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:camp_stay_permitted)
    assert_equal 500, final_state.money
    assert_equal 35, final_state.character(:ichiban).attribute(:hp)
    assert_equal :companion, final_state.character(:nanba).relationship(:ichiban)
  end

  def test_precondition_recovery_fails_without_saved_by_nanba
    scene = IchibanLab::Scene.new(id: :trash_pile_recovery)
    scene.add_precondition("Ichiban debe haber sido salvado por Nanba") { |ws| ws.flag?(:saved_by_nanba) }

    invalid_state = IchibanLab::WorldState.new(episode: "14", flags: { saved_by_nanba: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_14_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "14")
    assert_equal 0, status.exitstatus, "El CLI de episodio 14 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 14_la_ciudad_en_el_fondo"
  end
end
