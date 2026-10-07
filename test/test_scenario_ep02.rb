# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep02"
require "open3"

class TestScenarioEp02 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep02.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success]
    assert_equal "02_cobranza", outcome[:episode_id]

    state = outcome[:state]
    assert_equal "Callejón Nakamichi", state.location
    assert_equal 202_000, state.money
    assert state.flag?(:target_identified)
    assert state.flag?(:combat_resolved)
    assert state.flag?(:buyers_reimbursed)
    assert state.flag?(:debt_collected)

    ushio = state.character(:ushio)
    assert_equal :defeated, ushio.attribute(:status)
    assert_equal 0, ushio.attribute(:hp)

    ichiban = state.character(:ichiban)
    assert_equal :loyal_comrade, ichiban.relationship(:mitsuo)

    events = outcome[:events]
    assert events.has_event?("story.objective_started")
    assert events.has_event?("story.combat_resolved")
    assert events.has_event?("story.choice_recorded")
    assert events.has_event?("story.debt_collected")
  end

  def test_precondition_confrontation_fails_without_target_identification
    scene = IchibanLab::Scene.new(id: :ushio_den_confrontation)
    scene.add_precondition("Target identified") { |ws| ws.flag?(:target_identified) }

    raw_state = @scenario.send(:default_initial_state)
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(raw_state)
    end
  end

  def test_bin_episodio_02_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "02")
    assert_equal 0, status.exitstatus, "Expected exit code 0, stderr: #{stderr}"
    assert_includes stdout, "EPISODIO 02: EL TRABAJO DEL DÍA"
    assert_includes stdout, "story.debt_collected"
  end
end
