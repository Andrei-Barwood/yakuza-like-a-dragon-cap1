# frozen_string_literal: true

require_relative "test_helper"

class TestScene < Minitest::Test
  def test_precondition_satisfied
    scene = IchibanLab::Scene.new(id: :shangri_la, title: "Shangri-La entrance")
    scene.add_precondition("Must have plunger") do |state|
      state.has_item?(:plunger)
    end

    state = IchibanLab::WorldState.new(episode: "03", inventory: [:plunger])
    assert scene.check_preconditions!(state)
  end

  def test_precondition_failed_raises_precondition_error
    scene = IchibanLab::Scene.new(id: :shangri_la, title: "Shangri-La entrance")
    scene.add_precondition("Must have plunger") do |state|
      state.has_item?(:plunger)
    end

    state = IchibanLab::WorldState.new(episode: "03", inventory: [])
    err = assert_raises(IchibanLab::PreconditionError) do
      scene.check_preconditions!(state)
    end
    assert_includes err.message, "Must have plunger"
  end
end
