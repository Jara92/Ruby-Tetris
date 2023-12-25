require_relative 'vector'

=begin
Module to represent the four movement directions
=end
module Direction
  TOP = Vector.new(0, -1)
  BOTTOM = Vector.new(0, 1)
  LEFT = Vector.new(-1, 0)
  RIGHT = Vector.new(1, 0)
end
