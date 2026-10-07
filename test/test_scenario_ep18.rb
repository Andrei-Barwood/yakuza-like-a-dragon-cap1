# frozen_string_literal: true

require_relative "test_helper"
require "open3"
require "ichiban_lab/scenarios/ep18"

class TestScenarioEp18 < Minitest::Test
  def setup
    @scenario = IchibanLab::Scenarios::Ep18.new
  end

  def test_full_scenario_execution
    outcome = @scenario.run
    assert outcome[:success], "El Episodio 18 debe ejecutarse exitosamente"
    final_state = outcome[:state]

    assert final_state.flag?(:bleach_japan_repelled)
    assert final_state.flag?(:has_permanent_residence)
    assert final_state.flag?(:chapter_3_completed)
    assert_equal :hero, final_state.character(:ichiban).attribute(:calling)
    assert_equal "Sunrise Street, Ijincho", final_state.character(:ichiban).attribute(:address)
    assert_equal :sworn_partner, final_state.character(:nanba).relationship(:ichiban)

    boundary_event = outcome[:events].find_event("story.chapter_boundary")
    refute_nil boundary_event
    assert_equal 3, boundary_event.data[:chapter]
    assert_equal :concluded, boundary_event.data[:status]
    assert_equal :chapter_4, boundary_event.data[:next]
  end

  def test_precondition_cleanup_fails_without_harbor_light_defense
    scene = IchibanLab::Scene.new(id: :hamako_restaurant_cleanup)
    scene.add_precondition("The Harbor Light debe haber sido defendido con éxito") { |ws| ws.flag?(:harbor_light_defended) }

    invalid_state = IchibanLab::WorldState.new(episode: "18", flags: { harbor_light_defended: false })
    assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(invalid_state)
    end
  end

  def test_bin_episodio_18_execution_via_cli
    stdout, stderr, status = Open3.capture3("ruby", "-Ilib", "bin/episodio", "18")
    assert_equal 0, status.exitstatus, "El CLI de episodio 18 debe salir con código 0: #{stderr}"
    assert_includes stdout, "Episodio 18_un_techo_y_un_ideal"
  end
end
