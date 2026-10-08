# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep61"

class TestScenarioEp61 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep61.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 61 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:aoki_political_ascension_known)
    assert final_state.flag?(:zhao_and_han_integrated)
    assert final_state.flag?(:ogasawara_martyr_conspiracy_uncovered)
    assert final_state.flag?(:waiting_for_hamako_contact)

    broadcast_event = outcome[:events].find_event("story.political_broadcast_aired")
    refute_nil broadcast_event
    assert_equal :ryo_aoki, broadcast_event.actor

    party_event = outcome[:events].find_event("story.party_members_formalized")
    refute_nil party_event
    assert_includes party_event.data[:new_permanent_members], :zhao
    assert_includes party_event.data[:new_permanent_members], :joon_gi_han

    martyr_event = outcome[:events].find_event("story.ogasawara_martyrdom_analyzed")
    refute_nil martyr_event
    assert_equal :zhao, martyr_event.actor
  end

  def test_precondition_fails_without_chapter_10_completion
    scene = IchibanLab::Scene.new(id: :political_broadcast_and_survive_reunion)
    scene.add_precondition("El grupo debe haber completado el Capítulo 10") do |ws|
      ws.flag?(:chapter_10_completed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "61", flags: { chapter_10_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_61_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "61")
    assert_equal 0, status.exitstatus, "El CLI de episodio 61 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 61_el_ascenso_de_aoki"
  end
end
