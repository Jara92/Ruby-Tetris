require_relative 'direction'

class Shape

  attr_accessor :position, :layout

  # class methods
  def self.random_layout
    # shapes are represented as an array of rows
    shapes = [
      [[1, 1, 1, 1]],
      [[1, 1], [1, 1]],
      [[0, 1, 0], [1, 1, 1]],
      [[1, 1, 0], [0, 1, 1]],
      [[1, 1, 1], [0, 0, 1]],
    ]

    # Select the shape at random
    shape_index = rand(shapes.length)

    # Return a clone of the shape so that we don't modify the original
    shapes[shape_index].clone
  end

  def self.random_shape(position)
    Shape.new(position, Shape.random_layout)
  end

  # instance methods

  def initialize(position, layout)
    @position = position
    @layout = layout
  end

  def to_s
    @position.to_s
  end

  def rotate
    Shape.new(@position.clone, @layout.clone.transpose.map(&:reverse))
  end

  def rotate!
    @layout = rotate.layout
    self
  end

  def move(direction)
    Shape.new(@position.clone + direction, @layout.clone)
  end

  def move!(direction)
    @position = move(direction).position
    self
  end
end