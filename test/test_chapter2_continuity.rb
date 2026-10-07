# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep07"
require "ichiban_lab/scenarios/ep08"
require "ichiban_lab/scenarios/ep09"
require "ichiban_lab/scenarios/ep10"
require "ichiban_lab/scenarios/ep11"
require "ichiban_lab/scenarios/ep12"
require "ichiban_lab/scenarios/ep13"
require "open3"

class TestChapter2Continuity < Minitest::Test
  def test_handoff_from_chapter1_to_chapter2
    # Cierre del Capítulo 1
    ep07 = IchibanLab::Scenarios::Ep07.new
    outcome07 = ep07.run
    state07 = outcome07[:state]

    assert state07.flag?(:imprisoned)
    assert_equal :prisoner, state07.character(:ichiban).attribute(:role)
    assert_equal 0, state07.money

    # 18 años después (2019): Liberación en Ep08
    ep08 = IchibanLab::Scenarios::Ep08.new
    outcome08 = ep08.run
    state08 = outcome08[:state]

    assert_equal "2019 - Día", state08.time_period
    assert state08.flag?(:released_from_prison)
    assert_equal :kamurocho, state08.flag(:destination)
  end

  def test_sequential_chapter2_progression_from_ep08_to_ep13
    # 1. Ep 08: Salida de prisión
    ep08 = IchibanLab::Scenarios::Ep08.new
    outcome08 = ep08.run
    state08 = outcome08[:state]
    assert state08.flag?(:heard_arakawa_betrayal)

    # 2. Ep 09: El nuevo Kamurocho
    state08_for_09 = state08.deep_clone
    state08_for_09.episode = "09_el_nuevo_kamurocho"
    state08_for_09.scene_id = "tenkaichi_gate_arrival"
    state08_for_09.location = "Kamurocho - Tenkaichi Gate"
    state08_for_09.time_period = "2019 - Tarde"

    ep09 = IchibanLab::Scenarios::Ep09.new(state08_for_09)
    outcome09 = ep09.run
    state09 = outcome09[:state]
    assert_equal 3500, state09.money
    assert state09.flag?(:summit_meeting_discovered)
    assert_equal :find_way_into_summit, state09.flag(:next_objective)

    # 3. Ep 10: Rescate de Nick Ogata y alianza con Adachi
    state09_for_10 = state09.deep_clone
    state09_for_10.episode = "10_rescate_en_la_calle"
    state09_for_10.scene_id = "pink_street_alley_cry"
    state09_for_10.location = "Kamurocho - Callejón de Pink Street"
    state09_for_10.time_period = "2019 - Atardecer"

    ep10 = IchibanLab::Scenarios::Ep10.new(state09_for_10)
    outcome10 = ep10.run
    state10 = outcome10[:state]
    assert state10.has_item?(:nick_ogata_business_card)
    assert state10.flag?(:adachi_party_joined)
    assert_equal :enter_underground_sewers, state10.flag(:next_step)

    # 4. Ep 11: Conductos subterráneos
    state10_for_11 = state10.deep_clone
    state10_for_11.episode = "11_los_bajos_fondos"
    state10_for_11.scene_id = "sewer_descent"
    state10_for_11.location = "Alcantarillado de Kamurocho"
    state10_for_11.time_period = "2019 - Noche"

    ep11 = IchibanLab::Scenarios::Ep11.new(state10_for_11)
    outcome11 = ep11.run
    state11 = outcome11[:state]
    assert_equal "Sótano del Edificio de la Cumbre", state11.location
    assert state11.flag?(:building_infiltrated)
    assert_equal :storm_executive_floor, state11.flag(:next_step)

    # 5. Ep 12: Duelo con Sawashiro
    state11_for_12 = state11.deep_clone
    state11_for_12.episode = "12_el_guantelete"
    state11_for_12.scene_id = "stairs_breach_to_executive_floor"
    state11_for_12.location = "Planta Ejecutiva - Entrada"
    state11_for_12.time_period = "2019 - Noche cerrada"
    state11_for_12.add_character(IchibanLab::Character.new(id: :sawashiro, name: "Jo Sawashiro", attributes: { hp: 150, role: :omi_captain }))

    ep12 = IchibanLab::Scenarios::Ep12.new(state11_for_12)
    outcome12 = ep12.run
    state12 = outcome12[:state]
    assert state12.flag?(:sawashiro_boss_defeated)
    assert state12.flag?(:path_to_arakawa_opened)

    # 6. Ep 13: Reunión sangrienta y rescate en Yokohama
    state12_for_13 = state12.deep_clone
    state12_for_13.episode = "13_reunion_sangrienta"
    state12_for_13.scene_id = "the_patriarch_audience"
    state12_for_13.location = "Puertas del Despacho"
    state12_for_13.time_period = "2019 - Medianoche"
    state12_for_13.add_character(IchibanLab::Character.new(id: :arakawa, name: "Masumi Arakawa", attributes: { role: :omi_captain_leader }))

    ep13 = IchibanLab::Scenarios::Ep13.new(state12_for_13)
    outcome13 = ep13.run
    state13 = outcome13[:state]

    assert_equal "Isezaki Ijincho - Campamento de Vagabundos", state13.location
    assert state13.flag?(:shot_by_arakawa)
    assert state13.flag?(:saved_by_nanba)
    assert state13.flag?(:chapter_2_completed)
    assert_equal 1, state13.character(:ichiban).attribute(:hp)
    assert_equal :savior, state13.character(:ichiban).relationship(:nanba)

    boundary = outcome13[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 2, boundary.data[:chapter]
    assert_equal :chapter_3, boundary.data[:next]
  end

  def test_chapter2_cli_execution_episodes_08_to_13
    %w[08 09 10 11 12 13].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "Episode #{id} failed with stderr: #{stderr}"
      assert_includes stdout, "EPISODIO #{id}:"
    end
  end
end
