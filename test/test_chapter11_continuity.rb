# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep60"
require "ichiban_lab/scenarios/ep61"
require "ichiban_lab/scenarios/ep62"
require "ichiban_lab/scenarios/ep63"
require "ichiban_lab/scenarios/ep64"
require "ichiban_lab/scenarios/ep65"
require "ichiban_lab/scenarios/ep66"

class TestChapter11Continuity < Minitest::Test
  def test_handoff_from_chapter10_to_chapter11
    ep60 = IchibanLab::Scenarios::Ep60.new
    res60 = ep60.run
    state60 = res60[:state]

    assert state60.flag?(:chapter_10_completed)
    assert state60.flag?(:arakawa_protection_confirmed)

    ep61 = IchibanLab::Scenarios::Ep61.new(state60)
    res61 = ep61.run
    assert res61[:success]
    state61 = res61[:state]

    assert state61.flag?(:aoki_political_ascension_known)
    assert state61.flag?(:zhao_and_han_integrated)
  end

  def test_sequential_chapter11_progression_from_ep61_to_ep66
    # Inicia con el estado final de Ep60
    current_state = IchibanLab::Scenarios::Ep60.new.run[:state]

    [
      IchibanLab::Scenarios::Ep61,
      IchibanLab::Scenarios::Ep62,
      IchibanLab::Scenarios::Ep63,
      IchibanLab::Scenarios::Ep64,
      IchibanLab::Scenarios::Ep65,
      IchibanLab::Scenarios::Ep66
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep66
    assert current_state.flag?(:chapter_11_completed)
    assert current_state.flag?(:suzumori_true_killer_known)
    assert current_state.flag?(:hamako_workers_deported)
    assert current_state.flag?(:war_against_aoki_declared)
    assert_equal "Calles de Ijincho - Frente a Otohime Land", current_state.location
  end

  def test_chapter11_cli_execution_episodes_61_to_66
    %w[61 62 63 64 65 66].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
