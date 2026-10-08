# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep54"
require "ichiban_lab/scenarios/ep55"
require "ichiban_lab/scenarios/ep56"
require "ichiban_lab/scenarios/ep57"
require "ichiban_lab/scenarios/ep58"
require "ichiban_lab/scenarios/ep59"
require "ichiban_lab/scenarios/ep60"

class TestChapter10Continuity < Minitest::Test
  def test_handoff_from_chapter9_to_chapter10
    ep54 = IchibanLab::Scenarios::Ep54.new
    res54 = ep54.run
    state54 = res54[:state]

    assert state54.flag?(:chapter_9_completed)
    assert state54.flag?(:shoichi_confirmed_alive)

    ep55 = IchibanLab::Scenarios::Ep55.new(state54)
    res55 = ep55.run
    assert res55[:success]
    state55 = res55[:state]

    assert state55.flag?(:ogasawara_interrogated)
    assert state55.flag?(:zhao_rescue_mission_active)
  end

  def test_sequential_chapter10_progression_from_ep55_to_ep60
    # Inicia con el estado final de Ep54
    current_state = IchibanLab::Scenarios::Ep54.new.run[:state]

    [
      IchibanLab::Scenarios::Ep55,
      IchibanLab::Scenarios::Ep56,
      IchibanLab::Scenarios::Ep57,
      IchibanLab::Scenarios::Ep58,
      IchibanLab::Scenarios::Ep59,
      IchibanLab::Scenarios::Ep60
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep60
    assert current_state.flag?(:chapter_10_completed)
    assert current_state.flag?(:arakawa_protection_confirmed)
    assert current_state.flag?(:faith_in_arakawa_restored)
    assert current_state.flag?(:nanba_permanently_rejoined)
    assert current_state.flag?(:mabuchi_overthrown)
    assert_equal "Heian Tower - Restaurante Panorámico", current_state.location
  end

  def test_chapter10_cli_execution_episodes_55_to_60
    %w[55 56 57 58 59 60].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
