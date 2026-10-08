# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep78"
require "ichiban_lab/scenarios/ep79"
require "ichiban_lab/scenarios/ep80"
require "ichiban_lab/scenarios/ep81"
require "ichiban_lab/scenarios/ep82"
require "ichiban_lab/scenarios/ep83"
require "ichiban_lab/scenarios/ep84"

class TestChapter14Continuity < Minitest::Test
  def test_handoff_from_chapter13_to_chapter14
    ep78 = IchibanLab::Scenarios::Ep78.new
    res78 = ep78.run
    state78 = res78[:state]

    assert state78.flag?(:chapter_13_completed)
    assert state78.flag?(:biological_truth_unveiled)

    ep79 = IchibanLab::Scenarios::Ep79.new(state78)
    res79 = ep79.run
    assert res79[:success]
    state79 = res79[:state]

    assert state79.flag?(:resolve_to_find_aoki_formed)
    assert state79.flag?(:target_hakuryo_building_set)
  end

  def test_sequential_chapter14_progression_from_ep79_to_ep84
    # Inicia con el estado final de Ep78
    current_state = IchibanLab::Scenarios::Ep78.new.run[:state]

    [
      IchibanLab::Scenarios::Ep79,
      IchibanLab::Scenarios::Ep80,
      IchibanLab::Scenarios::Ep81,
      IchibanLab::Scenarios::Ep82,
      IchibanLab::Scenarios::Ep83,
      IchibanLab::Scenarios::Ep84
    ].each do |scenario_klass|
      scenario = scenario_klass.new(current_state)
      outcome = scenario.run
      assert outcome[:success], "#{scenario_klass} falló en la ejecución secuencial"
      current_state = outcome[:state]
    end

    # Verificaciones finales tras completar Ep84
    assert current_state.flag?(:chapter_14_completed)
    assert current_state.flag?(:kiryu_trial_fought)
    assert current_state.flag?(:mirror_face_identified)
    assert current_state.flag?(:tendo_culprit_revealed)
    assert_equal "Edificio de Ishioda - Despacho Principal", current_state.location
  end

  def test_chapter14_cli_execution_episodes_79_to_84
    %w[79 80 81 82 83 84].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "bin/episodio #{id} falló con código #{status.exitstatus}: #{stderr}"
      assert_includes stdout, "completado"
    end
  end
end
