# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep66"
require "ichiban_lab/scenarios/ep67"
require "ichiban_lab/scenarios/ep68"
require "ichiban_lab/scenarios/ep69"
require "ichiban_lab/scenarios/ep70"
require "ichiban_lab/scenarios/ep71"
require "ichiban_lab/scenarios/ep72"

class TestChapter12Continuity < Minitest::Test
  def test_handoff_from_chapter11_to_chapter12
    ep66 = IchibanLab::Scenarios::Ep66.new
    res66 = ep66.run
    state66 = res66[:state]

    assert state66.flag?(:chapter_11_completed)
    assert state66.flag?(:war_against_aoki_declared)

    ep67 = IchibanLab::Scenarios::Ep67.new(state66)
    res67 = ep67.run
    assert res67[:success]
    state67 = res67[:state]

    assert state67.flag?(:tendo_dispatched_to_osaka)
    assert state67.flag?(:watase_release_imminent)
  end

  def test_sequential_chapter12_progression_from_ep67_to_ep72
    # Inicia con el estado final de Ep66
    current_state = IchibanLab::Scenarios::Ep66.new.run[:state]

    [
      IchibanLab::Scenarios::Ep67,
      IchibanLab::Scenarios::Ep68,
      IchibanLab::Scenarios::Ep69,
      IchibanLab::Scenarios::Ep70,
      IchibanLab::Scenarios::Ep71,
      IchibanLab::Scenarios::Ep72
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep72
    assert current_state.flag?(:chapter_12_completed)
    assert current_state.flag?(:dissolution_formally_filed)
    assert current_state.flag?(:arakawa_reconciliation_sealed)
    assert current_state.flag?(:arakawa_deceased)
    assert_equal "Survive Bar - Yokohama", current_state.location
  end

  def test_chapter12_cli_execution_episodes_67_to_72
    %w[67 68 69 70 71 72].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
