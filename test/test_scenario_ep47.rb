# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep47"

class TestScenarioEp47 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep47.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 47 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:nanba_left_party)
    assert final_state.flag?(:founders_clipping_found)
    assert final_state.has_item?(:bleach_japan_founders_clipping)

    departure_event = outcome[:events].find_event("story.party_departure")
    refute_nil departure_event
    assert_equal :nanba, departure_event.actor

    founding_event = outcome[:events].find_event("story.founders_photograph_found")
    refute_nil founding_event
    assert_includes founding_event.data[:founders], "Ryo Aoki"
  end

  def test_precondition_fails_without_mabuchi_defeat
    scene = IchibanLab::Scene.new(id: :nanba_departure_scene)
    scene.add_precondition("Mabuchi debe haber sido vencido y la conspiración descubierta") do |ws|
      ws.flag?(:mabuchi_defeated)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "47", flags: { mabuchi_defeated: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_47_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "47")
    assert_equal 0, status.exitstatus, "El CLI de episodio 47 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 47_la_huida_de_nanba"
  end
end
