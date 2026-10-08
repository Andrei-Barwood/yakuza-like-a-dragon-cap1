# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep51"

class TestScenarioEp51 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep51.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 51 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:zhao_pact_honored)
    assert final_state.flag?(:kume_vanguard_dispersed)
    assert_equal "Isezaki Road - Perímetro de Koreatown", final_state.location

    intel_event = outcome[:events].find_event("story.zhao_intelligence_relayed")
    refute_nil intel_event
    assert_equal :tianyou_zhao, intel_event.actor

    march_event = outcome[:events].find_event("story.march_witnessed")
    refute_nil march_event
    assert_equal 1000, march_event.data[:crowd_size]

    kume_event = outcome[:events].find_event("story.kume_ignorance_admitted")
    refute_nil kume_event
    assert_equal :sota_kume, kume_event.actor
  end

  def test_precondition_fails_without_hamako_protected
    scene = IchibanLab::Scene.new(id: :zhao_urgent_call)
    scene.add_precondition("Hamako debe haber sido protegida del asedio de Totsuka") do |ws|
      ws.flag?(:hamako_protected)
    end

    invalid_state = IchibanLab::WorldState.new(episode: "51", flags: { hamako_protected: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_51_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "51")
    assert_equal 0, status.exitstatus, "El CLI de episodio 51 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 51_la_marcha_de_los_mil"
  end
end
