# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep60"

class TestScenarioEp60 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep60.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 60 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:arakawa_protection_confirmed)
    assert final_state.flag?(:faith_in_arakawa_restored)
    assert final_state.flag?(:chapter_10_completed)
    assert_equal "Heian Tower - Restaurante Panorámico", final_state.location

    corpse_event = outcome[:events].find_event("story.arakawa_corpse_protocol_revealed")
    refute_nil corpse_event
    assert_equal :homeless_chief, corpse_event.actor

    toshio_event = outcome[:events].find_event("story.toshio_murder_confessed")
    refute_nil toshio_event
    assert_equal :ryuhei_hoshino, toshio_event.actor

    bill_event = outcome[:events].find_event("story.defective_bill_1984_revealed")
    refute_nil bill_event
    assert_equal 1984, bill_event.data[:gift_year]

    motto_event = outcome[:events].find_event("story.engraved_motto_unveiled")
    refute_nil motto_event
    assert_includes motto_event.data[:motto], "Ni la justicia ni la piedad"

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 10, boundary_event.data[:chapter]
    assert_equal :chapter_11, boundary_event.data[:next]
  end

  def test_precondition_fails_without_mitsuo_intel
    scene = IchibanLab::Scene.new(id: :chief_confession_and_arakawa_orders)
    scene.add_precondition("El grupo debe haber recibido los informes de Mitsuo") do |ws|
      ws.flag?(:mitsuo_intel_received)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "60", flags: { mitsuo_intel_received: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_60_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "60")
    assert_equal 0, status.exitstatus, "El CLI de episodio 60 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 60_la_promesa_del_pato_de_pekin"
  end
end
