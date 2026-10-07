# frozen_string_literal: true

require_relative "test_helper"

class TestWorldState < Minitest::Test
  def setup
    @char = IchibanLab::Character.new(id: :ichiban, name: "Ichiban Kasuga")
    @state = IchibanLab::WorldState.new(
      episode: "02_cobranza",
      scene_id: :streets,
      location: "Kamurocho",
      time_period: "Día",
      money: 50_000,
      characters: { ichiban: @char },
      inventory: [:watch],
      flags: { met_mitsuo: true }
    )
  end

  def test_initial_state_attributes
    assert_equal "02_cobranza", @state.episode
    assert_equal "streets", @state.scene_id
    assert_equal "Kamurocho", @state.location
    assert_equal 50_000, @state.money
    assert @state.has_character?(:ichiban)
    assert @state.has_item?(:watch)
    assert @state.flag?(:met_mitsuo)
  end

  def test_inventory_and_money_mutations
    @state.add_item(:bento)
    assert @state.has_item?(:bento)

    @state.adjust_money(-10_000)
    assert_equal 40_000, @state.money

    @state.remove_item(:watch)
    refute @state.has_item?(:watch)
  end

  def test_flags_manipulation
    refute @state.flag?(:fought_ushio)
    @state.set_flag(:fought_ushio, true)
    assert @state.flag?(:fought_ushio)
  end

  def test_deep_clone_isolation
    clone = @state.deep_clone
    clone.adjust_money(20_000)
    clone.add_item(:phone)
    clone.set_flag(:new_flag, true)
    clone.character(:ichiban).set_attribute(:energy, 90)

    assert_equal 50_000, @state.money
    refute @state.has_item?(:phone)
    refute @state.flag?(:new_flag)
    assert_nil @state.character(:ichiban).attribute(:energy)

    assert_equal 70_000, clone.money
    assert clone.has_item?(:phone)
    assert clone.flag?(:new_flag)
    assert_equal 90, clone.character(:ichiban).attribute(:energy)
  end
end
