# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep81"

class TestScenarioEp81 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep81.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 81 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:horinouchi_subjugated)
    assert final_state.flag?(:ishioda_dispatched_with_hit)
    assert final_state.flag?(:ep81_completed)

    hoshino_blame_event = outcome[:events].find_event("story.aoki_blames_sawashiro_for_hoshino")
    refute_nil hoshino_blame_event
    assert_equal :ryo_aoki, hoshino_blame_event.actor
    assert_equal :juro_horinouchi, hoshino_blame_event.target

    ishioda_event = outcome[:events].find_event("story.ishioda_tokyo_omi_promotion_promise")
    refute_nil ishioda_event
    assert_equal :ryo_aoki, ishioda_event.actor
    assert_equal :akira_ishioda, ishioda_event.target
  end

  def test_precondition_fails_without_ep80_completion
    scene = IchibanLab::Scene.new(id: :governors_office_horinouchi_audience)
    scene.add_precondition("Ep80 debe haber concluido") do |ws|
      ws.flag?(:ep80_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "81", flags: { ep80_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_81_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "81")
    assert_equal 0, status.exitstatus, "El CLI de episodio 81 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 81_el_hilo_de_la_conspiracion"
  end
end
