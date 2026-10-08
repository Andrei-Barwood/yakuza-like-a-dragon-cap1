# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep78"

class TestScenarioEp78 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep78.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 78 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:seiryu_corridors_cleared)
    assert final_state.flag?(:sawashiro_duel_resolved)
    assert final_state.flag?(:sawashiro_secret_revealed)
    assert final_state.flag?(:biological_truth_unveiled)
    assert final_state.flag?(:chapter_13_completed)
    assert_equal :deceased, final_state.character(:ryuhei_hoshino).attributes[:status]

    invasion_event = outcome[:events].find_event("story.seiryu_hq_invasion_found")
    refute_nil invasion_event
    assert_equal :ichiban, invasion_event.actor
    assert_equal :mamoru_takabe, invasion_event.target

    hoshino_death_event = outcome[:events].find_event("story.hoshino_assassinated_by_sawashiro")
    refute_nil hoshino_death_event
    assert_equal :jo_sawashiro, hoshino_death_event.actor
    assert_equal :ryuhei_hoshino, hoshino_death_event.target

    coin_locker_event = outcome[:events].find_event("story.coin_locker_babies_confession")
    refute_nil coin_locker_event
    assert_equal :jo_sawashiro, coin_locker_event.actor
    assert_equal :ichiban, coin_locker_event.target
    assert_includes coin_locker_event.data[:biological_truth], "hijo_biologico_de_sawashiro"
    assert_includes coin_locker_event.data[:kasuga_lineage], "hijo_biologico_de_masumi_arakawa"

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 13, boundary_event.data[:chapter]
    assert_equal :chapter_14, boundary_event.data[:next]
  end

  def test_precondition_fails_without_ep77_completion
    scene = IchibanLab::Scene.new(id: :seiryu_hq_breach_and_bloodstained_corridors)
    scene.add_precondition("El episodio 77 debe haber finalizado y el asalto alertado") do |ws|
      ws.flag?(:ep77_completed) && ws.flag?(:seiryu_assault_alert_active)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "78", flags: { ep77_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_78_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "78")
    assert_equal 0, status.exitstatus, "El CLI de episodio 78 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 78_los_bebes_de_las_taquillas"
  end
end
