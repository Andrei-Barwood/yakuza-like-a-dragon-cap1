# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep31"

class TestScenarioEp31 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep31.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 31 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:party_restrained)
    assert final_state.flag?(:mabuchi_video_uploaded)
    assert final_state.flag?(:execution_ordered)
    assert outcome[:events].has_event?("story.confession_extracted")
  end

  def test_precondition_interrogation_fails_without_chapter5_completion
    scene = IchibanLab::Scene.new(id: :mabuchi_interrogation_room)
    scene.add_precondition("El grupo debe proceder de la destrucción del almacén") { |ws| ws.flag?(:chapter_5_completed) }

    invalid_state = IchibanLab::WorldState.new(episode: "31", flags: { chapter_5_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_31_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "31")
    assert_equal 0, status.exitstatus, "El CLI de episodio 31 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 31_el_despertar_encadenado"
  end
end
