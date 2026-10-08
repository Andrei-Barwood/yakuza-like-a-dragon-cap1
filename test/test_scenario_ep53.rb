# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep53"

class TestScenarioEp53 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep53.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 53 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:geomijul_scorched_earth_active)
    assert_equal "Base Central de Geomijul - Sala de Control", final_state.location

    contact_event = outcome[:events].find_event("story.precious_gift_call")
    refute_nil contact_event
    assert_equal :joon_gi_han, contact_event.actor

    passage_event = outcome[:events].find_event("story.secret_passage_unlocked")
    refute_nil passage_event

    bow_event = outcome[:events].find_event("story.leader_bow_witnessed")
    refute_nil bow_event
    assert_equal :seonhee, bow_event.actor

    agreement_event = outcome[:events].find_event("story.defense_agreement_sealed")
    refute_nil agreement_event
  end

  def test_precondition_fails_without_perimeter_breached
    scene = IchibanLab::Scene.new(id: :han_radio_contact)
    scene.add_precondition("El perímetro exterior de Geomijul debe haber caído") do |ws|
      ws.flag?(:geomijul_perimeter_breached)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "53", flags: { geomijul_perimeter_breached: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_53_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "53")
    assert_equal 0, status.exitstatus, "El CLI de episodio 53 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 53_el_voto_de_eomeoni"
  end
end
