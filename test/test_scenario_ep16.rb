# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep16"

class TestScenarioEp16 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep16.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 16 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:party_chats_active)
    assert final_state.flag?(:lacked_official_address)
    assert final_state.flag?(:harbor_light_job_accepted)
    assert_equal 1300, final_state.money
  end

  def test_precondition_rally_fails_without_bill_revealed
    scene = IchibanLab::Scene.new(id: :speech_and_rally)
    scene.add_precondition("El misterio del billete falso debe estar iniciado") { |ws| ws.flag?(:counterfeit_bill_revealed) }

    invalid_state = IchibanLab::WorldState.new(episode: "16", flags: { counterfeit_bill_revealed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_16_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "16")
    assert_equal 0, status.exitstatus, "El CLI de episodio 16 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 16_en_busca_de_empleo"
  end
end
