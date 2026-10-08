# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep72"

class TestScenarioEp72 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep72.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 72 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:arakawa_reconciliation_sealed)
    assert final_state.flag?(:arakawa_deceased)
    assert final_state.flag?(:chapter_12_completed)
    assert_equal "Survive Bar - Yokohama", final_state.location

    rendezvous_event = outcome[:events].find_event("story.hamakita_nocturne_rendezvous")
    refute_nil rendezvous_event
    assert_equal :masumi_arakawa, rendezvous_event.actor

    bond_event = outcome[:events].find_event("story.father_and_son_bond_unspoken")
    refute_nil bond_event
    assert_equal :masumi_arakawa, bond_event.actor
    assert_includes bond_event.data[:dream_confession], "intercambiaban_sus_posiciones_al_nacer"

    corpse_event = outcome[:events].find_event("story.arakawa_corpse_found_in_ocean")
    refute_nil corpse_event
    assert_equal :ryuhei_hoshino, corpse_event.actor
    assert_equal :ichiban, corpse_event.target

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 12, boundary_event.data[:chapter]
    assert_equal :chapter_13, boundary_event.data[:next]
  end

  def test_precondition_fails_without_dissolution_filed
    scene = IchibanLab::Scene.new(id: :hamakita_park_night_reunion)
    scene.add_precondition("La disolución de los clanes debe estar registrada") do |ws|
      ws.flag?(:dissolution_formally_filed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "72", flags: { dissolution_formally_filed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_72_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "72")
    assert_equal 0, status.exitstatus, "El CLI de episodio 72 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 72_la_noche_en_hamakita_y_el_golpe"
  end
end
