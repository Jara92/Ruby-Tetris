class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def ==(other)
    return false if not other.is_a?(Vector)

    @x == other.x && @y == other.y
  end

  def +(other)
    raise TypeError if not other.is_a?(Vector)

    Vector.new(@x + other.x, @y + other.y)
  end

  def -(other)
    raise TypeError if not other.is_a?(Vector)

    Vector.new(@x - other.x, @y - other.y)
  end
end
