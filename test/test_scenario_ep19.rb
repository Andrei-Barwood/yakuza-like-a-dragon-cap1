# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep19"

class TestScenarioEp19 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep19.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 19 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:officially_registered_jobseeker)
    assert final_state.flag?(:adachi_rejoined_party)
    assert final_state.flag?(:otohime_land_assigned)
    assert_equal :ally, final_state.character(:ichiban).relationship(:adachi)
  end

  def test_precondition_interview_fails_without_residence
    scene = IchibanLab::Scene.new(id: :hello_work_with_address)
    scene.add_precondition("Ichiban debe tener domicilio legal acreditado") { |ws| ws.flag?(:has_permanent_residence) }

    invalid_state = IchibanLab::WorldState.new(episode: "19", flags: { has_permanent_residence: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_19_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "19")
    assert_equal 0, status.exitstatus, "El CLI de episodio 19 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 19_el_empleo_prometido"
  end
end
