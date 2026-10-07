# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep36"
require "ichiban_lab/scenarios/ep37"
require "ichiban_lab/scenarios/ep38"
require "ichiban_lab/scenarios/ep39"
require "ichiban_lab/scenarios/ep40"
require "ichiban_lab/scenarios/ep41"
require "ichiban_lab/scenarios/ep42"

class TestChapter7Continuity < Minitest::Test
  def test_handoff_from_chapter6_to_chapter7
    ep36 = IchibanLab::Scenarios::Ep36.new
    res36 = ep36.run
    state36 = res36[:state]

    assert state36.flag?(:chapter_6_completed)
    assert state36.flag?(:geomijul_lead_unlocked)
    assert state36.flag?(:temporary_ceasefire_active)

    ep37 = IchibanLab::Scenarios::Ep37.new(state36)
    res37 = ep37.run
    assert res37[:success]
    state37 = res37[:state]

    assert state37.flag?(:mysterious_woman_followed)
    assert state37.flag?(:geomijul_entrance_reached)
  end

  def test_sequential_chapter7_progression_from_ep37_to_ep42
    # Inicia con el estado final de Ep36
    current_state = IchibanLab::Scenarios::Ep36.new.run[:state]

    [
      IchibanLab::Scenarios::Ep37,
      IchibanLab::Scenarios::Ep38,
      IchibanLab::Scenarios::Ep39,
      IchibanLab::Scenarios::Ep40,
      IchibanLab::Scenarios::Ep41,
      IchibanLab::Scenarios::Ep42
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep42
    assert current_state.flag?(:chapter_7_completed)
    assert current_state.flag?(:ijin_three_summit_concluded)
    assert current_state.flag?(:ogikubo_conspiracy_revealed)
    assert current_state.has_item?(:shoichi_investigative_notes)
    assert_equal "Heian Tower - Mirador Panorámico", current_state.location
  end

  def test_chapter7_cli_execution_episodes_37_to_42
    %w[37 38 39 40 41 42].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
