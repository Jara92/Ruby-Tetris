require_relative 'configuration'
require_relative 'vector'
require_relative 'board'
require_relative 'shape'
require_relative 'timer'

class GameManager
  attr_reader :board, :shape, :timer

  def initialize()
    @board = Board.new(Configuration::BOARD_WIDTH, Configuration::BOARD_HEIGHT)

    @speed = Configuration::INITIAL_SPEED
    @timer = Timer.new(@speed)

    @exit = false
    @paused = false

    spawn_shape
  end

  def update
    if not @paused
      shape_fall
    end
  end

  def start
    @timer.start
  end

  def running
    not @exit
  end

  def exit
    @exit = true
  end

  def toggle_pause
    @paused = !@paused
  end

  def paused?
    @paused
  end

  def move_shape( direction)
    return if @paused

    if @board.can_move?(@shape, direction)
      @shape.move!(direction)
    end
  end

  def rotate_shape
    return if @paused

    if @board.can_rotate?(@shape)
      @shape.rotate!
    end
  end

  private

  def shape_fall
    if @timer.tick?
      @timer.update_wait_time(@speed)
      @timer.reset

      moved_shape = @shape.move(Direction::BOTTOM)
      if @board.is_colliding?(moved_shape)
        @board.add_shape(@shape)
        spawn_shape
      else
        @shape.move!(Direction::BOTTOM) # TODO: replay by @shape = moved_shape
      end
    end
  end

  def spawn_shape()
    @shape = Shape.random_shape(Vector.new(@board.width / 2, 0))

    if @board.is_colliding?(@shape)
      # TODO: game over
    end
  end

end