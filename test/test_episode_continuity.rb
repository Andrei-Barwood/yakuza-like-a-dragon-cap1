# frozen_string_literal: true

require_relative "test_helper"
require "ichiban_lab/scenarios/ep01"
require "ichiban_lab/scenarios/ep02"
require "ichiban_lab/scenarios/ep03"
require "ichiban_lab/scenarios/ep04"
require "ichiban_lab/scenarios/ep05"
require "ichiban_lab/scenarios/ep06"
require "ichiban_lab/scenarios/ep07"
require "open3"

class TestEpisodeContinuity < Minitest::Test
  def test_ep01_prologue_isolation
    ep01 = IchibanLab::Scenarios::Ep01.new
    outcome01 = ep01.run

    assert outcome01[:success]
    assert_equal "01_origen", outcome01[:episode_id]
    assert_equal "1977 - Noche", outcome01[:state].time_period
    assert outcome01[:state].flag?(:toshio_deceased)

    # Ep02 default initial state has no dependency on Ep01 state
    ep02 = IchibanLab::Scenarios::Ep02.new
    outcome02 = ep02.run
    assert outcome02[:success]
    assert_equal "2000 - Mañana", outcome02[:state].time_period
    assert_equal :ichiban, outcome02[:state].character(:ichiban).id
  end

  def test_sequential_adult_continuity_from_ep02_to_ep07
    # 1. Ep02: Cobranza a Ushio
    ep02 = IchibanLab::Scenarios::Ep02.new
    outcome02 = ep02.run
    state02 = outcome02[:state]

    assert_equal 202_000, state02.money
    assert state02.flag?(:buyers_reimbursed)

    # 2. Ep03: Encargo de Michiyo y Shangri-La
    state02_for_03 = state02.deep_clone
    state02_for_03.episode = "03_encargo_urgente"
    state02_for_03.scene_id = "michiyo_request"
    state02_for_03.location = "Shangri-La exterior"
    state02_for_03.time_period = "2000 - Mediodía"
    state02_for_03.add_character(IchibanLab::Character.new(id: :michiyo, name: "Michiyo", attributes: { role: :shangri_la_manager }))

    ep03 = IchibanLab::Scenarios::Ep03.new(state02_for_03)
    outcome03 = ep03.run
    state03 = outcome03[:state]

    assert_equal 202_000, state03.money
    assert state03.flag?(:shangri_la_unclogged)
    assert_equal :hiratsuka, state03.flag(:next_assignment_target)

    # 3. Ep04: Deuda de Hiratsuka en Public Park 3
    state03_for_04 = state03.deep_clone
    state03_for_04.episode = "04_lo_que_se_debe"
    state03_for_04.scene_id = "park_confrontation"
    state03_for_04.location = "Kamurocho - Public Park 3"
    state03_for_04.time_period = "2000 - Tarde"
    state03_for_04.add_character(IchibanLab::Character.new(id: :hiratsuka, name: "Koji Hiratsuka", attributes: { hp: 80, role: :debtor }))

    ep04 = IchibanLab::Scenarios::Ep04.new(state03_for_04)
    outcome04 = ep04.run
    state04 = outcome04[:state]

    assert_equal 252_000, state04.money # 202,000 + 50,000 cobrados
    assert state04.flag?(:hiratsuka_spared)
    assert state04.flag?(:sawashiro_summons)
    assert_equal :masato, state04.flag(:next_assignment_target)

    # 4. Ep05: Acompañar a Masato
    state04_for_05 = state04.deep_clone
    state04_for_05.episode = "05_el_joven_maestro"
    state04_for_05.scene_id = "escorting_masato"
    state04_for_05.location = "Kamurocho - Pink Street"
    state04_for_05.time_period = "2000 - Noche"
    state04_for_05.add_character(IchibanLab::Character.new(id: :masato, name: "Masato Arakawa", attributes: { mobility: :wheelchair }, belongings: [:masato_wallet]))

    ep05 = IchibanLab::Scenarios::Ep05.new(state04_for_05)
    outcome05 = ep05.run
    state05 = outcome05[:state]

    assert state05.has_item?(:masato_wallet)
    assert state05.flag?(:heard_yumeno_truth)
    assert state05.flag?(:masato_departed)

    # 5. Ep06: Familia Arakawa y cena
    state05_for_06 = state05.deep_clone
    state05_for_06.episode = "06_lo_que_nos_une"
    state05_for_06.scene_id = "office_reprimand"
    state05_for_06.location = "Oficina Familia Arakawa"
    state05_for_06.time_period = "2000 - Medianoche"
    state05_for_06.add_character(IchibanLab::Character.new(id: :sawashiro, name: "Jo Sawashiro", attributes: { role: :captain }))
    state05_for_06.add_character(IchibanLab::Character.new(id: :arakawa, name: "Masumi Arakawa", attributes: { role: :patriarch }))

    ep06 = IchibanLab::Scenarios::Ep06.new(state05_for_06)
    outcome06 = ep06.run
    state06 = outcome06[:state]

    refute state06.has_item?(:masato_wallet)
    assert_equal 2000, state06.money # ¥250,000 entregados a la familia
    assert state06.flag?(:funds_deposited)
    assert state06.flag?(:resting_for_night)
    assert_equal :father_figure, state06.character(:ichiban).relationship(:arakawa)

    # 6. Ep07: La mañana del crimen y entrega voluntaria
    state06_for_07 = state06.deep_clone
    state06_for_07.episode = "07_el_precio"
    state06_for_07.scene_id = "new_years_awakening"
    state06_for_07.location = "Apartamento de Ichiban"
    state06_for_07.time_period = "2001 - 1 de Enero (Mañana)"

    ep07 = IchibanLab::Scenarios::Ep07.new(state06_for_07)
    outcome07 = ep07.run
    state07 = outcome07[:state]

    assert_equal "Centro de Detención de Kamurocho", state07.location
    assert_equal 0, state07.money
    assert_empty state07.inventory
    assert state07.flag?(:imprisoned)
    assert state07.flag?(:chapter_1_completed)
    assert_equal :prisoner, state07.character(:ichiban).attribute(:role)

    # Verificación de frontera del capítulo
    boundary = outcome07[:events].find_event("story.chapter_boundary")
    refute_nil boundary
    assert_equal 1, boundary.data[:chapter]
    assert_equal :out_of_scope, boundary.data[:next]
  end

  def test_all_seven_episodes_executable_via_cli_with_exit_code_0
    %w[01 02 03 04 05 06 07].each do |id|
      stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", id)
      assert_equal 0, status.exitstatus, "Episode #{id} failed with stderr: #{stderr}"
      assert_includes stdout, "EPISODIO #{id}:"
    end
  end
end
