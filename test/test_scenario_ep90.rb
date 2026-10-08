# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep90"

class TestScenarioEp90 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep90.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 90 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:horinouchi_arrested)
    assert final_state.flag?(:funeral_concluded)
    assert final_state.flag?(:chapter_15_completed)
    assert final_state.flag?(:campaign_completed)

    horinouchi_event = outcome[:events].find_event("story.horinouchi_confrontation_and_arrest")
    refute_nil horinouchi_event
    assert_equal :adachi, horinouchi_event.actor
    assert_equal :juro_horinouchi, horinouchi_event.target

    funeral_event = outcome[:events].find_event("story.arakawa_funeral_and_sawashiro_fate")
    refute_nil funeral_event
    assert_equal :yu_nanba, funeral_event.actor
    assert_equal :ichiban, funeral_event.target

    offer_event = outcome[:events].find_event("story.osaka_security_company_offer")
    refute_nil offer_event
    assert_equal :daigo_dojima, offer_event.actor
    assert_equal :ichiban, offer_event.target

    finale_event = outcome[:events].find_event("story.the_end_of_an_upstart")
    refute_nil finale_event
    assert_equal :ichiban, finale_event.actor

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 15, boundary_event.data[:chapter]
    assert_equal :grand_finale, boundary_event.data[:status]
    assert_equal :completed, boundary_event.data[:campaign]
  end

  def test_precondition_fails_without_ep89_completion
    scene = IchibanLab::Scene.new(id: :horinouchi_rooftop_arrest)
    scene.add_precondition("El episodio 89 debe estar completado") do |ws|
      ws.flag?(:ep89_completed) && ws.flag?(:aoki_fatally_stabbed)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "90", flags: { ep89_completed: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_90_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "90")
    assert_equal 0, status.exitstatus, "El CLI de episodio 90 debe salir con código 0: #{stderr}"
    assert_includes stdout, "EPISODIO 90: HACIA LA CIMA"
  end
end
