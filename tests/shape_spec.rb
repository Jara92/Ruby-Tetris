# my_class_spec.rb
require 'rspec'
require_relative '../src/shape'

describe Shape do
  describe 'rotate' do
    it 'simulates rotation of the shape' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])
      rotated_shape = shape.rotate

      # Original shape should be the same
      expect(shape.layout).to eq([[1, 1, 1, 1]])

      # Rotated shape should be this
      expect(rotated_shape.layout).to eq([[1], [1], [1], [1]])

      # After another 3 rotations, the shape should be the same as the original
      expect(rotated_shape.rotate.rotate.rotate.layout).to eq(shape.layout)
    end
  end

  describe 'rotate!' do
    it 'rotates the shape' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])

      # Rotate the shape
      shape.rotate!

      # The shape should be rotated
      expect(shape.layout).to eq([[1], [1], [1], [1]])

      # Rotate the shape again
      shape.rotate!

      # The shape should be the same as the original
      expect(shape.layout).to eq([[1, 1, 1, 1]])
    end
  end

  describe 'move' do
    it 'simulates movement of the shape in X direction' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])

      # The shape should move to right
      moved_shape = shape.move(Direction::RIGHT)
      expect(moved_shape.position).to eq(Vector.new(1, 0))

      # The shape should move to left
      moved_shape = moved_shape.move(Direction::LEFT)
      expect(moved_shape.position).to eq(Vector.new(0, 0))

      # the shape can move to left again - the X coord may be < 0
      moved_shape = moved_shape.move(Direction::LEFT)
      expect(moved_shape.position).to eq(Vector.new(-1, 0))
    end
  end

  describe 'move' do
    it 'simulates movement of the shape in Y direction' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])

      # The shape should move to bottom
      moved_shape = shape.move(Direction::BOTTOM)
      expect(moved_shape.position).to eq(Vector.new(0, 1))

      # The shape should move to top
      moved_shape = moved_shape.move(Direction::TOP)
      expect(moved_shape.position).to eq(Vector.new(0, 0))

      # the shape can move to top again - the Y coord may be < 0
      moved_shape = moved_shape.move(Direction::TOP)
      expect(moved_shape.position).to eq(Vector.new(0, -1))
    end
  end

  describe 'move!' do
    it 'moves the shape in X direction' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])

      # The shape should move to right
      shape.move!(Direction::RIGHT)
      expect(shape.position).to eq(Vector.new(1, 0))

      # The shape should move to left
      shape.move!(Direction::LEFT)
      expect(shape.position).to eq(Vector.new(0, 0))

      # the shape can move to left again - the X coord may be < 0
      shape.move!(Direction::LEFT)
      expect(shape.position).to eq(Vector.new(-1, 0))
    end
  end

  describe 'move!' do
    it 'moves the shape in Y direction' do
      shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])

      # The shape should move to bottom
      shape.move!(Direction::BOTTOM)
      expect(shape.position).to eq(Vector.new(0, 1))

      # The shape should move to top
      shape.move!(Direction::TOP)
      expect(shape.position).to eq(Vector.new(0, 0))

      # the shape can move to top again - the Y coord may be < 0
      shape.move!(Direction::TOP)
      expect(shape.position).to eq(Vector.new(0, -1))
    end
  end
end
