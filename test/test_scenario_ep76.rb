# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep76"

class TestScenarioEp76 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep76.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 76 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:campaign_van_deployed)
    assert final_state.flag?(:hamakita_debate_won)
    assert final_state.flag?(:sawashiro_ultimatum_issued)
    assert final_state.flag?(:ep76_completed)

    smear_event = outcome[:events].find_event("story.kume_smear_campaign_stickers")
    refute_nil smear_event
    assert_equal :sota_kume, smear_event.actor
    assert_equal :ichiban, smear_event.target

    debate_event = outcome[:events].find_event("story.philosophical_gray_zone_debate")
    refute_nil debate_event
    assert_equal :ichiban, debate_event.actor
    assert_equal :sota_kume, debate_event.target

    retreat_event = outcome[:events].find_event("story.kume_humiliated_retreat")
    refute_nil retreat_event
    assert_equal :sota_kume, retreat_event.actor

    ultimatum_event = outcome[:events].find_event("story.aoki_rage_24h_ultimatum")
    refute_nil ultimatum_event
    assert_equal :ryo_aoki, ultimatum_event.actor
    assert_equal :jo_sawashiro, ultimatum_event.target
  end

  def test_precondition_fails_without_active_candidacy
    scene = IchibanLab::Scene.new(id: :survive_bar_campaign_stickers)
    scene.add_precondition("La candidatura debe estar registrada y ep75 concluido") do |ws|
      ws.flag?(:ep75_completed) && ws.flag?(:kasuga_candidacy_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "76", flags: { ep75_completed: true, kasuga_candidacy_active: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_76_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "76")
    assert_equal 0, status.exitstatus, "El CLI de episodio 76 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 76_el_debate_en_hamakita"
  end
end
