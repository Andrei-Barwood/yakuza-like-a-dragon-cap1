# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require_relative "../lib/ichiban_lab/scenarios/ep13"
require_relative "../lib/ichiban_lab/scenarios/ep14"
require_relative "../lib/ichiban_lab/scenarios/ep15"
require_relative "../lib/ichiban_lab/scenarios/ep16"
require_relative "../lib/ichiban_lab/scenarios/ep17"
require_relative "../lib/ichiban_lab/scenarios/ep18"

class TestChapter3Continuity < Minitest::Test
  def test_handoff_from_chapter2_to_chapter3
    ep13_res = IchibanLab::Scenarios::Ep13.new.run
    assert ep13_res[:success]
    end_of_c2 = ep13_res[:state]

    assert end_of_c2.flag?(:saved_by_nanba)
    assert end_of_c2.flag?(:shot_by_arakawa)
    assert end_of_c2.has_character?(:nanba)

    # Iniciar Ep 14 alimentándolo con el estado real final del Capítulo 2
    state_ep14 = end_of_c2.deep_clone
    state_ep14.episode = "14_la_ciudad_en_el_fondo"
    state_ep14.scene_id = "trash_pile_recovery"
    state_ep14.location = "Isezaki Ijincho - Vertedero de Basura"
    state_ep14.time_period = "2019 - Mañana (3 días después del disparo)"
    state_ep14.money = 0
    state_ep14.add_character(IchibanLab::Character.new(id: :chief, name: "Jefe del Campamento", attributes: { role: :settlement_leader }))

    ep14_res = IchibanLab::Scenarios::Ep14.new(state_ep14).run
    assert ep14_res[:success]
    assert ep14_res[:state].flag?(:camp_stay_permitted)
  end

  def test_sequential_chapter3_progression_from_ep14_to_ep18
    # 1. Ep 14
    res14 = IchibanLab::Scenarios::Ep14.new.run
    assert res14[:success]
    st14 = res14[:state]
    assert_equal 500, st14.money

    # 2. Ep 15
    st15_input = st14.deep_clone
    st15_input.episode = "15_la_ley_del_campamento"
    st15_input.scene_id = "can_collection_dawn"
    st15_input.time_period = "2019 - 05:30 AM"
    st15_input.add_character(IchibanLab::Character.new(id: :zheng, name: "Zheng", attributes: { role: :liumang_collector, hp: 120 }))

    res15 = IchibanLab::Scenarios::Ep15.new(st15_input).run
    assert res15[:success]
    st15 = res15[:state]
    assert_equal 1300, st15.money
    assert st15.has_item?(:counterfeit_10k_bill)

    # 3. Ep 16
    st16_input = st15.deep_clone
    st16_input.episode = "16_en_busca_de_empleo"
    st16_input.scene_id = "speech_and_rally"
    st16_input.time_period = "2019 - Mediodía"
    st16_input.add_character(IchibanLab::Character.new(id: :ririka, name: "Ririka", attributes: { role: :hello_work_clerk }))
    st16_input.add_character(IchibanLab::Character.new(id: :kanbe, name: "Director Shuichi Kanbe", attributes: { role: :hello_work_director }))

    res16 = IchibanLab::Scenarios::Ep16.new(st16_input).run
    assert res16[:success]
    st16 = res16[:state]
    assert st16.flag?(:harbor_light_job_accepted)

    # 4. Ep 17
    st17_input = st16.deep_clone
    st17_input.episode = "17_defensa_de_harbor_light"
    st17_input.scene_id = "harbor_light_briefing"
    st17_input.location = "The Harbor Light Bar"
    st17_input.time_period = "2019 - Noche"
    st17_input.add_character(IchibanLab::Character.new(id: :hamako, name: "Hamako", attributes: { role: :harbor_light_owner }))
    st17_input.add_character(IchibanLab::Character.new(id: :matsuo, name: "Matsuo", attributes: { role: :geomijul_saboteur, hp: 150 }))

    res17 = IchibanLab::Scenarios::Ep17.new(st17_input).run
    assert res17[:success]
    st17 = res17[:state]
    assert_equal 6300, st17.money
    assert st17.flag?(:harbor_light_defended)

    # 5. Ep 18
    st18_input = st17.deep_clone
    st18_input.episode = "18_un_techo_y_un_ideal"
    st18_input.scene_id = "hamako_restaurant_cleanup"
    st18_input.location = "Restaurante de Hamako (Sunrise Street)"
    st18_input.time_period = "2019 - Mañana siguiente"
    st18_input.add_character(IchibanLab::Character.new(id: :kume, name: "Sota Kume", attributes: { role: :bleach_japan_branch_leader }))
    st18_input.add_character(IchibanLab::Character.new(id: :hooligans, name: "Matones de Bleach Japan", attributes: { hp: 160 }))

    res18 = IchibanLab::Scenarios::Ep18.new(st18_input).run
    assert res18[:success]
    st18 = res18[:state]

    # Validaciones del clímax del Capítulo 3
    assert st18.flag?(:has_permanent_residence)
    assert_equal :hero, st18.character(:ichiban).attribute(:calling)
    assert_equal "Sunrise Street, Ijincho", st18.character(:ichiban).attribute(:address)
    assert_equal :sworn_partner, st18.character(:nanba).relationship(:ichiban)
    assert_equal 6300, st18.money
    assert st18.has_item?(:counterfeit_10k_bill)

    boundary = res18[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 3, boundary.data[:chapter]
  end

  def test_chapter3_cli_execution_episodes_14_to_18
    %w[14 15 16 17 18].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "El episodio #{id} falló vía CLI: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
