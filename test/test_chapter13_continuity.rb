# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep72"
require "ichiban_lab/scenarios/ep73"
require "ichiban_lab/scenarios/ep74"
require "ichiban_lab/scenarios/ep75"
require "ichiban_lab/scenarios/ep76"
require "ichiban_lab/scenarios/ep77"
require "ichiban_lab/scenarios/ep78"

class TestChapter13Continuity < Minitest::Test
  def test_handoff_from_chapter12_to_chapter13
    ep72 = IchibanLab::Scenarios::Ep72.new
    res72 = ep72.run
    state72 = res72[:state]

    assert state72.flag?(:chapter_12_completed)
    assert state72.flag?(:arakawa_deceased)

    ep73 = IchibanLab::Scenarios::Ep73.new(state72)
    res73 = ep73.run
    assert res73[:success]
    state73 = res73[:state]

    assert state73.flag?(:police_cordon_restrained)
    assert state73.flag?(:heian_briefing_received)
    assert state73.flag?(:tokyo_omi_tension_escalated)
  end

  def test_sequential_chapter13_progression_from_ep73_to_ep78
    # Inicia con el estado final de Ep72
    current_state = IchibanLab::Scenarios::Ep72.new.run[:state]

    [
      IchibanLab::Scenarios::Ep73,
      IchibanLab::Scenarios::Ep74,
      IchibanLab::Scenarios::Ep75,
      IchibanLab::Scenarios::Ep76,
      IchibanLab::Scenarios::Ep77,
      IchibanLab::Scenarios::Ep78
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep78
    assert current_state.flag?(:chapter_13_completed)
    assert current_state.flag?(:kasuga_candidacy_active)
    assert current_state.flag?(:hamakita_debate_won)
    assert current_state.flag?(:public_handshake_completed)
    assert current_state.flag?(:sawashiro_secret_revealed)
    assert current_state.flag?(:biological_truth_unveiled)
    assert_equal :deceased, current_state.character(:ryuhei_hoshino).attributes[:status]
    assert_equal "Sede del Clan Seiryu - Despacho del Presidente", current_state.location
  end

  def test_chapter13_cli_execution_episodes_73_to_78
    %w[73 74 75 76 77 78].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "completado"
    end
  end
end
