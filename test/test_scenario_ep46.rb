# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep46"

class TestScenarioEp46 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep46.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 46 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:mabuchi_defeated)
    assert final_state.flag?(:omi_invasion_alert_active)

    boss_event = outcome[:events].find_event("story.boss_defeated")
    refute_nil boss_event
    assert_equal :akira_mabuchi, boss_event.target

    nonomiya_event = outcome[:events].find_event("story.nonomiya_killer_revealed")
    refute_nil nonomiya_event
    assert_equal "Hajime Ogasawara", nonomiya_event.data[:instigator]

    omi_event = outcome[:events].find_event("story.omi_invasion_revealed")
    refute_nil omi_event
    assert_includes omi_event.data[:threat], "alianza_omi"
  end

  def test_precondition_fails_without_bleach_japan_office_reached
    scene = IchibanLab::Scene.new(id: :ogasawara_office_confrontation)
    scene.add_precondition("La oficina de Bleach Japan debe haber sido alcanzada") do |ws|
      ws.flag?(:bleach_japan_office_reached)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "46", flags: { bleach_japan_office_reached: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_46_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "46")
    assert_equal 0, status.exitstatus, "El CLI de episodio 46 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 46_la_caida_de_mabuchi"
  end
end
