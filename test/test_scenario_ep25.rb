# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep25"

class TestScenarioEp25 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep25.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 25 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:saeko_joined_party)
    assert final_state.flag?(:mabuchi_investigation_started)
    assert_equal :ally, final_state.character(:saeko).relationship(:ichiban)
  end

  def test_precondition_crime_fails_without_nonomiya_death
    scene = IchibanLab::Scene.new(id: :otohime_land_crime_scene)
    scene.add_precondition("Nonomiya debe haber sido encontrado muerto") { |ws| ws.flag?(:nonomiya_found_dead) }

    invalid_state = IchibanLab::WorldState.new(episode: "25", flags: { nonomiya_found_dead: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_25_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "25")
    assert_equal 0, status.exitstatus, "El CLI de episodio 25 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 25_la_heredera_de_otohime"
  end
end
