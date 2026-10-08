# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep85"

class TestScenarioEp85 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep85.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 85 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:campaign_bluff_executed)
    assert final_state.flag?(:millennium_trap_prepared)
    assert final_state.flag?(:ep85_completed)

    infiltration_event = outcome[:events].find_event("story.campaign_infiltration")
    refute_nil infiltration_event
    assert_equal :ichiban, infiltration_event.actor
    assert_equal :ryo_aoki, infiltration_event.target

    bluff_event = outcome[:events].find_event("story.incriminating_tape_bluff")
    refute_nil bluff_event
    assert_includes bluff_event.data[:threat], "grabacion_en_el_despacho_arakawa"

    safehouse_event = outcome[:events].find_event("story.safehouse_established_new_serena")
    refute_nil safehouse_event
    assert_equal :adachi, safehouse_event.actor
    assert_equal :makoto_date, safehouse_event.target
  end

  def test_precondition_fails_without_chapter_14_completion
    scene = IchibanLab::Scene.new(id: :kamurocho_campaign_bluff)
    scene.add_precondition("El Capítulo 14 debe estar concluido") do |ws|
      ws.flag?(:chapter_14_completed) && ws.flag?(:tendo_culprit_revealed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "85", flags: { chapter_14_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_85_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "85")
    assert_equal 0, status.exitstatus, "El CLI de episodio 85 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 85: EL FAROL EN KAMUROCHO"
  end
end
