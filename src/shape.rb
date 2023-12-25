require_relative 'direction'

=begin
Tetris shape class
=end
class Shape

  attr_accessor :position, :layout

  # class methods
  "" "
  returns a random shape layout from the list of available shapes
  " ""

  def self.random_layout
    # shapes are represented as an array of rows
    shapes = [
      [[1, 1, 1, 1]],
      [[1, 1], [1, 1]],
      [[0, 1, 0], [1, 1, 1]],
      [[1, 1, 0], [0, 1, 1]],
      [[0, 1, 1], [1, 1, 0]],
      [[1, 1, 1], [0, 0, 1]],
      [[1, 0, 0], [1, 1, 1]],
    ]

    # Select the shape at random
    shape_index = rand(shapes.length)

    # Return a clone of the shape so that we don't modify the original
    shapes[shape_index].clone
  end

  "" "
  returns a random shape instance
  " ""

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

  "" "
  Rotate the shape 90 degrees clockwise and return a new shape instance
  " ""

  def rotate
    Shape.new(@position.clone, @layout.clone.transpose.map(&:reverse))
  end

  "" "
  Perform an in-place rotation of the shape 90 degrees clockwise and return self
  " ""

  def rotate!
    @layout = rotate.layout
    self
  end

  "" "
  Move the shape in the specified direction and return a new shape instance
  " ""

  def move(direction)
    Shape.new(@position.clone + direction, @layout.clone)
  end

  "" "
  Perform an in-place movement of the shape in the specified direction and return self
  " ""

  def move!(direction)
    @position = move(direction).position
    self
  end
end