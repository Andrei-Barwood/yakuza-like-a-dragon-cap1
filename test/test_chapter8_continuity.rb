# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep42"
require "ichiban_lab/scenarios/ep43"
require "ichiban_lab/scenarios/ep44"
require "ichiban_lab/scenarios/ep45"
require "ichiban_lab/scenarios/ep46"
require "ichiban_lab/scenarios/ep47"
require "ichiban_lab/scenarios/ep48"

class TestChapter8Continuity < Minitest::Test
  def test_handoff_from_chapter7_to_chapter8
    ep42 = IchibanLab::Scenarios::Ep42.new
    res42 = ep42.run
    state42 = res42[:state]

    assert state42.flag?(:chapter_7_completed)
    assert state42.flag?(:ijin_three_summit_concluded)

    ep43 = IchibanLab::Scenarios::Ep43.new(state42)
    res43 = ep43.run
    assert res43[:success]
    state43 = res43[:state]

    assert state43.flag?(:ogikubo_system_fully_understood)
  end

  def test_sequential_chapter8_progression_from_ep43_to_ep48
    # Inicia con el estado final de Ep42
    current_state = IchibanLab::Scenarios::Ep42.new.run[:state]

    [
      IchibanLab::Scenarios::Ep43,
      IchibanLab::Scenarios::Ep44,
      IchibanLab::Scenarios::Ep45,
      IchibanLab::Scenarios::Ep46,
      IchibanLab::Scenarios::Ep47,
      IchibanLab::Scenarios::Ep48
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep48
    assert current_state.flag?(:chapter_8_completed)
    assert current_state.flag?(:masato_arakawa_identity_revealed)
    assert current_state.flag?(:mabuchi_defeated)
    assert current_state.flag?(:nanba_left_party)
    assert current_state.has_item?(:bleach_japan_founders_clipping)
    assert_equal "Oficina del Gobernador de Tokio - Shinjuku", current_state.location
  end

  def test_chapter8_cli_execution_episodes_43_to_48
    %w[43 44 45 46 47 48].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
