# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep48"
require "ichiban_lab/scenarios/ep49"
require "ichiban_lab/scenarios/ep50"
require "ichiban_lab/scenarios/ep51"
require "ichiban_lab/scenarios/ep52"
require "ichiban_lab/scenarios/ep53"
require "ichiban_lab/scenarios/ep54"

class TestChapter9Continuity < Minitest::Test
  def test_handoff_from_chapter8_to_chapter9
    ep48 = IchibanLab::Scenarios::Ep48.new
    res48 = ep48.run
    state48 = res48[:state]

    assert state48.flag?(:chapter_8_completed)
    assert state48.flag?(:masato_arakawa_identity_revealed)

    ep49 = IchibanLab::Scenarios::Ep49.new(state48)
    res49 = ep49.run
    assert res49[:success]
    state49 = res49[:state]

    assert state49.flag?(:aoki_background_uncovered)
    assert state49.flag?(:survive_hideout_unlocked)
  end

  def test_sequential_chapter9_progression_from_ep49_to_ep54
    # Inicia con el estado final de Ep48
    current_state = IchibanLab::Scenarios::Ep48.new.run[:state]

    [
      IchibanLab::Scenarios::Ep49,
      IchibanLab::Scenarios::Ep50,
      IchibanLab::Scenarios::Ep51,
      IchibanLab::Scenarios::Ep52,
      IchibanLab::Scenarios::Ep53,
      IchibanLab::Scenarios::Ep54
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep54
    assert current_state.flag?(:chapter_9_completed)
    assert current_state.flag?(:omi_raid_repelled)
    assert current_state.flag?(:shoichi_confirmed_alive)
    assert_equal "Campamento de Indigentes - Orilla del Río", current_state.location
  end

  def test_chapter9_cli_execution_episodes_49_to_54
    %w[49 50 51 52 53 54].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
