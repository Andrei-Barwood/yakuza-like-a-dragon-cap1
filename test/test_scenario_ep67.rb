# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep67"

class TestScenarioEp67 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep67.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 67 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:tendo_dispatched_to_osaka)
    assert final_state.flag?(:watase_release_imminent)

    brief_event = outcome[:events].find_event("story.watase_release_briefed")
    refute_nil brief_event
    assert_equal :ryo_aoki, brief_event.actor

    pledge_event = outcome[:events].find_event("story.sawashiro_priority_confirmed")
    refute_nil pledge_event
    assert_equal :jo_sawashiro, pledge_event.actor

    tendo_event = outcome[:events].find_event("story.tendo_dispatched_to_osaka")
    refute_nil tendo_event
    assert_equal "sotenbori_osaka", tendo_event.data[:destination]
  end

  def test_precondition_fails_without_chapter_11_completion
    scene = IchibanLab::Scene.new(id: :governor_office_distrust_session)
    scene.add_precondition("El grupo debe haber completado el Capítulo 11") do |ws|
      ws.flag?(:chapter_11_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "67", flags: { chapter_11_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_67_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "67")
    assert_equal 0, status.exitstatus, "El CLI de episodio 67 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 67_el_despacho_del_gobernador"
  end
end
