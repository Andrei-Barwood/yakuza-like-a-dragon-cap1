# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep84"
require "ichiban_lab/scenarios/ep85"
require "ichiban_lab/scenarios/ep86"
require "ichiban_lab/scenarios/ep87"
require "ichiban_lab/scenarios/ep88"
require "ichiban_lab/scenarios/ep89"
require "ichiban_lab/scenarios/ep90"

class TestChapter15Continuity < Minitest::Test
  def test_handoff_from_chapter14_to_chapter15
    sc84 = IchibanLab::Scenarios::Ep84.new
    res84 = sc84.run
    assert res84[:success]
    state84 = res84[:state]

    assert state84.flag?(:chapter_14_completed)
    assert state84.flag?(:tendo_culprit_revealed)

    boundary = res84[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 14, boundary.data[:chapter]
    assert_equal :chapter_15, boundary.data[:next]

    sc85 = IchibanLab::Scenarios::Ep85.new(state84)
    res85 = sc85.run
    assert res85[:success]
    assert res85[:state].flag?(:ep85_completed)
  end

  def test_sequential_chapter15_progression_from_ep85_to_ep90
    current_state = nil

    # Ep 85: El farol en Kamurocho
    res85 = IchibanLab::Scenarios::Ep85.new.run
    assert res85[:success]
    assert res85[:state].flag?(:ep85_completed)
    current_state = res85[:state]

    # Ep 86: La cumbre de la Torre Milenio
    res86 = IchibanLab::Scenarios::Ep86.new(current_state).run
    assert res86[:success]
    assert res86[:state].flag?(:tendo_defeated)
    assert res86[:state].flag?(:ep86_completed)
    current_state = res86[:state]

    # Ep 87: La trampa del camaleón
    res87 = IchibanLab::Scenarios::Ep87.new(current_state).run
    assert res87[:success]
    assert res87[:state].flag?(:aoki_publicly_exposed)
    assert res87[:state].flag?(:ep87_completed)
    current_state = res87[:state]

    # Ep 88: El fin del advenedizo
    res88 = IchibanLab::Scenarios::Ep88.new(current_state).run
    assert res88[:success]
    assert res88[:state].flag?(:aoki_duel_won)
    assert res88[:state].flag?(:aoki_escaped_to_streets)
    assert res88[:state].flag?(:ep88_completed)
    current_state = res88[:state]

    # Ep 89: Las taquillas del destino
    res89 = IchibanLab::Scenarios::Ep89.new(current_state).run
    assert res89[:success]
    assert res89[:state].flag?(:aoki_fatally_stabbed)
    assert res89[:state].flag?(:ep89_completed)
    current_state = res89[:state]

    # Ep 90: Hacia la cima (Gran Final)
    res90 = IchibanLab::Scenarios::Ep90.new(current_state).run
    assert res90[:success]
    assert res90[:state].flag?(:chapter_15_completed)
    assert res90[:state].flag?(:campaign_completed)

    boundary = res90[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 15, boundary.data[:chapter]
    assert_equal :grand_finale, boundary.data[:status]
    assert_equal :completed, boundary.data[:campaign]
  end

  def test_chapter15_cli_execution_episodes_85_to_90
    (85..90).each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id.to_s)
      assert_equal 0, status.exitstatus, "El episodio #{id} debe salir con 0 en CLI: #{stderr}"
      assert_includes stdout, "EPISODIO #{id}:"
    end
  end
end
