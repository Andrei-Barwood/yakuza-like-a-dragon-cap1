# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep71"

class TestScenarioEp71 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep71.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 71 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:kiryu_guardian_revealed)
    assert final_state.flag?(:dissolution_formally_filed)
    assert_equal "Jefatura de Policía de la Prefectura de Osaka", final_state.location

    tendo_event = outcome[:events].find_event("story.tendo_opportunist_alliance")
    refute_nil tendo_event
    assert_equal :yosuke_tendo, tendo_event.actor

    rebels_event = outcome[:events].find_event("story.omi_rebels_overwhelmed")
    refute_nil rebels_event
    assert_equal :ichiban, rebels_event.actor

    kiryu_event = outcome[:events].find_event("story.kiryu_tanto_deflection_and_defense")
    refute_nil kiryu_event
    assert_equal :kazuma_kiryu, kiryu_event.actor
    assert_equal :masaru_watase, kiryu_event.target

    filed_event = outcome[:events].find_event("story.dissolution_paperwork_submitted")
    refute_nil filed_event
    assert_equal :masaru_watase, filed_event.actor
  end

  def test_precondition_fails_without_joint_dissolution_proclamation
    scene = IchibanLab::Scene.new(id: :mass_brawl_at_omi_headquarters)
    scene.add_precondition("La disolución debe haber sido proclamada") do |ws|
      ws.flag?(:joint_dissolution_proclaimed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "71", flags: { joint_dissolution_proclaimed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_71_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "71")
    assert_equal 0, status.exitstatus, "El CLI de episodio 71 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 71_la_gran_batalla_de_la_omi"
  end
end
