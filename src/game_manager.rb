require_relative 'configuration'
require_relative 'vector'
require_relative 'board'
require_relative 'shape'
require_relative 'timer'
require_relative 'score_manager'

class GameManager
  attr_reader :board, :shape, :timer, :score, :level, :speed

  def initialize()
    @board = Board.new(Configuration::BOARD_WIDTH, Configuration::BOARD_HEIGHT)

    @level = 1
    @speed = Configuration::INITIAL_SPEED
    @timer = Timer.new(@speed)
    @score_manager = ScoreManager.instance

    @score = 0
    @score_for_next_level = Configuration::FIRST_LEVEL_UP_SCORE

    @exit = false
    @paused = false
    @game_over = false

    spawn_shape
  end

  def update
    if not @paused and not @game_over
      shape_fall

      squash_rows
    end
  end

  def squash_rows
    squash_rows_count = 0

    (0...@board.height).each { |row_index|
      if @board.row_full?(row_index)
        @board.squash_row(row_index)
        squash_rows_count += 1
      end
    }

    add_score(squash_rows_count ** 2)
  end

  def start
    @timer.start
  end

  def running?
    not @exit
  end

  def exit
    @exit = true

    update_top_score
  end

  def toggle_pause
    @paused = !@paused
  end

  def paused?
    @paused
  end

  def game_over?
    @game_over
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


  def shape_fall
    if @timer.tick?
      @timer.change_wait_time(@speed)
      @timer.reset

      moved_shape = @shape.move(Direction::BOTTOM)
      if @board.colliding?(moved_shape)
        @board.add_shape(@shape)
        spawn_shape
      else
        @shape.move!(Direction::BOTTOM) # TODO: replay by @shape = moved_shape
      end
    end
  end

  def spawn_shape()
    @shape = Shape.random_shape(Vector.new(@board.width / 2 - 1, 0))

    if @board.colliding?(@shape)
      @game_over = true
    end
  end

  def game_over
    @paused = false
    @game_over = true
    @timer.stop

    update_top_score

  end

  def update_top_score
    if @score > @score_manager.get_top_score
      @score_manager.save_top_score(@score)
    end
  end

  def add_score(score)
    @score += score

    # Next level score reached?
    if @score >= @score_for_next_level
      # Level up
      @level += 1

      # Increase the speed by multiplying it with the factor
      @speed *= Configuration::FALLING_SPEED_FACTOR
      # Update the wait time of the timer
      @timer.change_wait_time(@speed)

      # Increase the score for the next level
      @score_for_next_level *= Configuration::SCORE_NEXT_LEVEL_FACTOR
    end
  end

end