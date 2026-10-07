# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require_relative "../lib/ichiban_lab/scenarios/ep24"
require_relative "../lib/ichiban_lab/scenarios/ep25"
require_relative "../lib/ichiban_lab/scenarios/ep26"
require_relative "../lib/ichiban_lab/scenarios/ep27"
require_relative "../lib/ichiban_lab/scenarios/ep28"
require_relative "../lib/ichiban_lab/scenarios/ep29"
require_relative "../lib/ichiban_lab/scenarios/ep30"

class TestChapter5Continuity < Minitest::Test
  def test_handoff_from_chapter4_to_chapter5
    ep24_res = IchibanLab::Scenarios::Ep24.new.run
    assert ep24_res[:success]
    end_of_c4 = ep24_res[:state]

    assert end_of_c4.flag?(:nonomiya_found_dead)
    assert_equal 26300, end_of_c4.money

    # Iniciar Ep 25 alimentándolo con el estado real final del Capítulo 4
    state_ep25 = end_of_c4.deep_clone
    state_ep25.episode = "25_la_heredera_de_otohime"
    state_ep25.scene_id = "otohime_land_crime_scene"
    state_ep25.location = "Otohime Land Soapland - Despacho de Nonomiya"
    state_ep25.time_period = "2019 - Noche del incidente"
    state_ep25.add_character(IchibanLab::Character.new(id: :saeko, name: "Saeko Mukoda", attributes: { role: :otohime_hostess, grief: :seeking_truth }))

    ep25_res = IchibanLab::Scenarios::Ep25.new(state_ep25).run
    assert ep25_res[:success]
    assert ep25_res[:state].flag?(:saeko_joined_party)
  end

  def test_sequential_chapter5_progression_from_ep25_to_ep30
    # 1. Ep 25
    res25 = IchibanLab::Scenarios::Ep25.new.run
    assert res25[:success]
    st25 = res25[:state]

    # 2. Ep 26
    st26_input = st25.deep_clone
    st26_input.episode = "26_el_club_lin_lin"
    st26_input.scene_id = "lin_lin_vip_infiltration"
    st26_input.location = "Lin Lin Hostess Bar - Sala VIP"
    st26_input.time_period = "2019 - Noche"
    st26_input.add_character(IchibanLab::Character.new(id: :zheng, name: "Zheng", attributes: { role: :liumang_club_manager, hp: 200 }))

    res26 = IchibanLab::Scenarios::Ep26.new(st26_input).run
    assert res26[:success]
    st26 = res26[:state]
    assert st26.flag?(:yokohama_trading_identified)

    # 3. Ep 27
    st27_input = st26.deep_clone
    st27_input.episode = "27_el_cambio_de_oficio"
    st27_input.scene_id = "hello_work_job_system"
    st27_input.location = "Oficina de Hello Work Yokohama"
    st27_input.time_period = "2019 - Mañana"
    st27_input.add_character(IchibanLab::Character.new(id: :ririka, name: "Ririka", attributes: { role: :job_counselor }))
    st27_input.add_character(IchibanLab::Character.new(id: :kanbe, name: "Director Shuichi Kanbe", attributes: { role: :hello_work_director }))

    res27 = IchibanLab::Scenarios::Ep27.new(st27_input).run
    assert res27[:success]
    st27 = res27[:state]
    assert st27.flag?(:dock_infiltration_active)

    # 4. Ep 28
    st28_input = st27.deep_clone
    st28_input.episode = "28_la_resistencia_vecinal"
    st28_input.scene_id = "bleach_japan_otohime_protest"
    st28_input.location = "Exterior de Otohime Land"
    st28_input.time_period = "2019 - Mañana"
    st28_input.add_character(IchibanLab::Character.new(id: :kume, name: "Sota Kume", attributes: { role: :bleach_japan_branch_leader }))
    st28_input.add_character(IchibanLab::Character.new(id: :bleach_mob, name: "Manifestantes de Bleach Japan", attributes: { hp: 180 }))

    res28 = IchibanLab::Scenarios::Ep28.new(st28_input).run
    assert res28[:success]
    st28 = res28[:state]
    assert st28.flag?(:bleach_japan_humiliated)

    # 5. Ep 29
    st29_input = st28.deep_clone
    st29_input.episode = "29_la_imprenta_clandestina"
    st29_input.scene_id = "cash_shortage_incident"
    st29_input.location = "Yokohama Trading Company - Oficina Principal"
    st29_input.time_period = "2019 - Mañana"
    st29_input.add_character(IchibanLab::Character.new(id: :yan, name: "Yan", attributes: { role: :warehouse_overseer }))

    res29 = IchibanLab::Scenarios::Ep29.new(st29_input).run
    assert res29[:success]
    st29 = res29[:state]
    assert st29.flag?(:sample_extraction_ready)

    # 6. Ep 30
    st30_input = st29.deep_clone
    st30_input.episode = "30_explosion_en_el_muelle"
    st30_input.scene_id = "handover_fumble_and_clash"
    st30_input.location = "Yokohama Trading Company - Almacén del Muelle"
    st30_input.time_period = "2019 - Tarde"
    st30_input.add_character(IchibanLab::Character.new(id: :liumang_foreman, name: "Capataz de Liumang", attributes: { role: :warehouse_enforcer, hp: 220 }))

    res30 = IchibanLab::Scenarios::Ep30.new(st30_input).run
    assert res30[:success]
    st30 = res30[:state]

    # Validaciones del desenlace del Capítulo 5
    assert st30.has_item?(:counterfeit_yuan_sample)
    assert st30.flag?(:warehouse_destroyed)
    assert st30.flag?(:chapter_5_completed)
    assert_equal 26300, st30.money

    boundary = res30[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 5, boundary.data[:chapter]
  end

  def test_chapter5_cli_execution_episodes_25_to_30
    %w[25 26 27 28 29 30].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "El episodio #{id} falló vía CLI: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
