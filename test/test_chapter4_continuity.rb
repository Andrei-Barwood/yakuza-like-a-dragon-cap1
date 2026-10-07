# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require_relative "../lib/ichiban_lab/scenarios/ep18"
require_relative "../lib/ichiban_lab/scenarios/ep19"
require_relative "../lib/ichiban_lab/scenarios/ep20"
require_relative "../lib/ichiban_lab/scenarios/ep21"
require_relative "../lib/ichiban_lab/scenarios/ep22"
require_relative "../lib/ichiban_lab/scenarios/ep23"
require_relative "../lib/ichiban_lab/scenarios/ep24"

class TestChapter4Continuity < Minitest::Test
  def test_handoff_from_chapter3_to_chapter4
    ep18_res = IchibanLab::Scenarios::Ep18.new.run
    assert ep18_res[:success]
    end_of_c3 = ep18_res[:state]

    assert end_of_c3.flag?(:has_permanent_residence)
    assert_equal :hero, end_of_c3.character(:ichiban).attribute(:calling)
    assert_equal "Sunrise Street, Ijincho", end_of_c3.character(:ichiban).attribute(:address)

    # Iniciar Ep 19 alimentándolo con el estado real final del Capítulo 3
    state_ep19 = end_of_c3.deep_clone
    state_ep19.episode = "19_el_empleo_prometido"
    state_ep19.scene_id = "hello_work_with_address"
    state_ep19.location = "Oficina de Hello Work Yokohama"
    state_ep19.time_period = "2019 - Mañana"
    state_ep19.add_character(IchibanLab::Character.new(id: :ririka, name: "Ririka", attributes: { role: :hello_work_clerk }))
    state_ep19.add_character(IchibanLab::Character.new(id: :adachi, name: "Koichi Adachi", attributes: { role: :former_detective }))
    state_ep19.add_character(IchibanLab::Character.new(id: :nonomiya, name: "Nonomiya", attributes: { role: :otohime_land_manager }))

    ep19_res = IchibanLab::Scenarios::Ep19.new(state_ep19).run
    assert ep19_res[:success]
    assert ep19_res[:state].flag?(:officially_registered_jobseeker)
  end

  def test_sequential_chapter4_progression_from_ep19_to_ep24
    # 1. Ep 19
    res19 = IchibanLab::Scenarios::Ep19.new.run
    assert res19[:success]
    st19 = res19[:state]

    # 2. Ep 20
    st20_input = st19.deep_clone
    st20_input.episode = "20_otohime_land"
    st20_input.scene_id = "otohime_land_briefing"
    st20_input.location = "Otohime Land Soapland"
    st20_input.time_period = "2019 - Tarde"
    st20_input.add_character(IchibanLab::Character.new(id: :nanoha, name: "Nanoha Mukoda", attributes: { role: :soapland_worker, status: :exhausted }))

    res20 = IchibanLab::Scenarios::Ep20.new(st20_input).run
    assert res20[:success]
    st20 = res20[:state]
    assert st20.flag?(:sunlight_castle_located)

    # 3. Ep 21
    st21_input = st20.deep_clone
    st21_input.episode = "21_el_castillo_de_la_luz"
    st21_input.scene_id = "kanbe_placement"
    st21_input.location = "Oficina de Hello Work Yokohama"
    st21_input.time_period = "2019 - Noche"
    st21_input.add_character(IchibanLab::Character.new(id: :kanbe, name: "Director Shuichi Kanbe", attributes: { role: :hello_work_director }))

    res21 = IchibanLab::Scenarios::Ep21.new(st21_input).run
    assert res21[:success]
    st21 = res21[:state]
    assert st21.flag?(:pension_scam_uncovered)
    assert st21.flag?(:tatsuro_rescue_urgent)

    # 4. Ep 22
    st22_input = st21.deep_clone
    st22_input.episode = "22_la_noche_en_survive"
    st22_input.scene_id = "arrival_at_survive"
    st22_input.location = "Survive Bar (Bar District)"
    st22_input.time_period = "2019 - Madrugada"
    st22_input.add_character(IchibanLab::Character.new(id: :iroha, name: "Iroha Yanagi", attributes: { role: :survive_bar_hostess }))

    res22 = IchibanLab::Scenarios::Ep22.new(st22_input).run
    assert res22[:success]
    st22 = res22[:state]
    assert st22.flag?(:survive_bar_unlocked)
    assert st22.flag?(:ready_to_breach_sunlight)

    # 5. Ep 23
    st23_input = st22.deep_clone
    st23_input.episode = "23_el_rescate_de_tatsuro"
    st23_input.scene_id = "sunlight_castle_breach"
    st23_input.location = "Sunlight Castle - Pasillos VIP"
    st23_input.time_period = "2019 - Mañana"
    st23_input.add_character(IchibanLab::Character.new(id: :corrupt_doctor, name: "Médico de Sunlight Castle", attributes: { role: :lethal_injector }))
    st23_input.add_character(IchibanLab::Character.new(id: :totsuka, name: "Yamato Totsuka", attributes: { role: :ryuto_family_patriarch, hp: 180 }))

    res23 = IchibanLab::Scenarios::Ep23.new(st23_input).run
    assert res23[:success]
    st23 = res23[:state]
    assert st23.flag?(:tatsuro_mukoda_rescued)
    assert st23.flag?(:escorting_totsuka_to_seiryu)

    # 6. Ep 24
    st24_input = st23.deep_clone
    st24_input.episode = "24_el_dragon_del_seiryu"
    st24_input.scene_id = "seiryu_headquarters_infiltration"
    st24_input.location = "Sede del Clan Seiryu - Pasillos interiores"
    st24_input.time_period = "2019 - Mediodía"
    st24_input.add_character(IchibanLab::Character.new(id: :hoshino, name: "Ryuhei Hoshino", attributes: { role: :seiryu_clan_chairman }))
    st24_input.add_character(IchibanLab::Character.new(id: :takabe, name: "Mamoru Takabe", attributes: { role: :seiryu_clan_captain }))

    res24 = IchibanLab::Scenarios::Ep24.new(st24_input).run
    assert res24[:success]
    st24 = res24[:state]

    # Validaciones del desenlace del Capítulo 4
    assert st24.flag?(:hoshino_respected_ichiban)
    assert st24.flag?(:nonomiya_found_dead)
    assert st24.flag?(:chapter_4_completed)
    assert_equal 26300, st24.money

    boundary = res24[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 4, boundary.data[:chapter]
  end

  def test_chapter4_cli_execution_episodes_19_to_24
    %w[19 20 21 22 23 24].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "El episodio #{id} falló vía CLI: #{stderr}"
      assert_includes stdout, "Episodio #{id}_"
    end
  end
end
