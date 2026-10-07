# frozen_string_literal: true

require_relative "test_helper"

class TestCharacter < Minitest::Test
  def test_initialization_with_valid_attributes
    char = IchibanLab::Character.new(
      id: :ichiban,
      name: "Ichiban Kasuga",
      attributes: { hp: 100, role: :yakuza },
      relationships: { arakawa: :patriarch },
      belongings: [:lighter]
    )

    assert_equal :ichiban, char.id
    assert_equal "Ichiban Kasuga", char.name
    assert_equal 100, char.attribute(:hp)
    assert_equal :patriarch, char.relationship(:arakawa)
    assert char.has_belonging?(:lighter)
  end

  def test_initialization_requires_id_and_name
    assert_raises(ArgumentError) { IchibanLab::Character.new(id: nil, name: "Test") }
    assert_raises(ArgumentError) { IchibanLab::Character.new(id: :test, name: "") }
  end

  def test_mutate_attributes_and_relationships
    char = IchibanLab::Character.new(id: :mitsuo, name: "Mitsuo")
    char.set_attribute(:morale, :high)
    char.set_relationship(:ichiban, :aniki)

    assert_equal :high, char.attribute(:morale)
    assert_equal :aniki, char.relationship(:ichiban)
  end

  def test_belongings_manipulation
    char = IchibanLab::Character.new(id: :ichiban, name: "Ichiban")
    char.add_belonging(:wallet)
    assert char.has_belonging?(:wallet)

    char.remove_belonging(:wallet)
    refute char.has_belonging?(:wallet)
  end

  def test_deep_clone_isolation
    char = IchibanLab::Character.new(
      id: :ichiban,
      name: "Ichiban",
      attributes: { hp: 100 },
      belongings: [:ring]
    )
    clone = char.deep_clone
    clone.set_attribute(:hp, 50)
    clone.remove_belonging(:ring)

    assert_equal 100, char.attribute(:hp)
    assert char.has_belonging?(:ring)
    assert_equal 50, clone.attribute(:hp)
    refute clone.has_belonging?(:ring)
  end
end
