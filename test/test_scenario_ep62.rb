# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep62"

class TestScenarioEp62 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep62.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 62 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:shelter_scam_suspected)
    assert final_state.flag?(:funeral_target_identified)

    hamako_event = outcome[:events].find_event("story.hamako_request_received")
    refute_nil hamako_event
    assert_equal :hamako, hamako_event.actor

    shelter_event = outcome[:events].find_event("story.bleach_japan_shelters_exposed")
    refute_nil shelter_event
    assert_equal "hamakita_park", shelter_event.data[:shelter_location]

    funeral_event = outcome[:events].find_event("story.funeral_attendance_alerted")
    refute_nil funeral_event
    assert_equal :ryo_aoki, funeral_event.data[:attendee]
  end

  def test_precondition_fails_without_hamako_contact
    scene = IchibanLab::Scene.new(id: :hamako_call_and_arrival)
    scene.add_precondition("Hamako debe haber convocado al grupo") do |ws|
      ws.flag?(:waiting_for_hamako_contact)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "62", flags: { waiting_for_hamako_contact: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_62_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "62")
    assert_equal 0, status.exitstatus, "El CLI de episodio 62 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 62_el_refugio_de_hamako"
  end
end
