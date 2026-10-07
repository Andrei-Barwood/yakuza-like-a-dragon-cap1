# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep04"
require "open3"

class TestScenarioEp04 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep04.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "04_lo_que_se_debe", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Kamurocho - Public Park 3", state.location
    assert_equal 252_000, state.money
    assert state.flag?(:hiratsuka_spared)
    assert state.flag?(:partial_collection)
    assert state.flag?(:sawashiro_summons)
    assert_equal :masato, state.flag(:next_assignment_target)

    hiratsuka = state.character(:hiratsuka)
    assert_equal :defeated, hiratsuka.attribute(:status)
    assert_equal 0, hiratsuka.attribute(:hp)

    events = outcome[:events]
    assert events.has_event?("story.objective_started")
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.choice_recorded")
    assert events.has_event?("story.debt_collected")
    assert events.has_event?("story.communication_received")
  end

  def test_precondition_confrontation_fails_without_target
    scene = IchibanLab::Scene.new(id: :park_confrontation)
    scene.add_precondition("El objetivo debe ser Hiratsuka") { |ws| ws.flag(:next_assignment_target) == :hiratsuka }

    invalid_state = IchibanLab::WorldState.new(episode: "04", flags: { next_assignment_target: :someone_else })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_04_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "04")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 04: COBRAR SIN DESTRUIR"
    assert_includes stdout, "story.debt_collected"
  end
end
