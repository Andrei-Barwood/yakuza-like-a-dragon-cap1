# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep30"
require "ichiban_lab/scenarios/ep31"
require "ichiban_lab/scenarios/ep32"
require "ichiban_lab/scenarios/ep33"
require "ichiban_lab/scenarios/ep34"
require "ichiban_lab/scenarios/ep35"
require "ichiban_lab/scenarios/ep36"

class TestChapter6Continuity < Minitest::Test
  def test_handoff_from_chapter5_to_chapter6
    ep30 = IchibanLab::Scenarios::Ep30.new
    res30 = ep30.run
    state30 = res30[:state]

    assert state30.flag?(:chapter_5_completed)
    assert state30.has_item?(:counterfeit_yuan_sample)

    ep31 = IchibanLab::Scenarios::Ep31.new(state30)
    res31 = ep31.run
    assert res31[:success]
    state31 = res31[:state]

    assert state31.flag?(:party_restrained)
    assert state31.flag?(:execution_ordered)
  end

  def test_sequential_chapter6_progression_from_ep31_to_ep36
    # Inicia con el estado final de Ep30
    current_state = IchibanLab::Scenarios::Ep30.new.run[:state]

    [
      IchibanLab::Scenarios::Ep31,
      IchibanLab::Scenarios::Ep32,
      IchibanLab::Scenarios::Ep33,
      IchibanLab::Scenarios::Ep34,
      IchibanLab::Scenarios::Ep35,
      IchibanLab::Scenarios::Ep36
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep36
    assert current_state.flag?(:chapter_6_completed)
    assert current_state.flag?(:temporary_ceasefire_active)
    assert current_state.flag?(:geomijul_lead_unlocked)
    assert_equal "Restaurante Qing Jin - Entrada Principal", current_state.location
  end

  def test_chapter6_cli_execution_episodes_31_to_36
    %w[31 32 33 34 35 36].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
