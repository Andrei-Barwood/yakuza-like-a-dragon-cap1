# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep13"
require "open3"

class TestScenarioEp13 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep13.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "13_reunion_sangrienta", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Isezaki Ijincho - Campamento de Vagabundos", state.location
    assert_equal "2019 - Madrugada", state.time_period
    assert state.flag?(:faced_arakawa)
    assert state.flag?(:shot_by_arakawa)
    assert state.flag?(:dumped_in_yokohama)
    assert state.flag?(:saved_by_nanba)
    assert state.flag?(:chapter_2_completed)

    ichiban = state.character(:ichiban)
    assert_equal 1, ichiban.attribute(:hp)
    assert_equal :critically_wounded, ichiban.attribute(:status)
    assert_equal :betrayed_by_father, ichiban.relationship(:arakawa)
    assert_equal :savior, ichiban.relationship(:nanba)

    events = outcome[:events]
    assert events.has_event?("story.arakawa_betrayal_shot")
    assert events.has_event?("story.medical_treatment")

    boundary = events.find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 2, boundary.data[:chapter]
    assert_equal :chapter_3, boundary.data[:next]
  end

  def test_precondition_audience_fails_without_opened_path
    scene = IchibanLab::Scene.new(id: :the_patriarch_audience)
    scene.add_precondition("El camino debe estar abierto") { |ws| ws.flag?(:path_to_arakawa_opened) }

    invalid_state = IchibanLab::WorldState.new(episode: "13", flags: {})
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_13_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "13")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 13: REUNIÓN SANGRIENTA"
    assert_includes stdout, "story.arakawa_betrayal_shot"
  end
end
