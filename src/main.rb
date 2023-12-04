require 'curses'
require_relative 'shape'
require_relative 'direction'
require_relative 'board'
require_relative 'configuration'
require_relative 'timer'

include Curses

class Tetris

  def init_curses(screen_size)
    Curses.init_screen
    Curses.curs_set(0) # Hide the cursor
    @win = Curses::Window.new(screen_size.y, screen_size.x, 0, 0) # height comes first
    @win.timeout = 100 # Set a timeout for getch in milliseconds
    @win.box('|', '-')
    @win.addstr('Tetris')
    @win.refresh
  end

  def initialize

    board_size = Vector.new(Configuration::BOARD_WIDTH, Configuration::BOARD_HEIGHT)
    screen_size = board_size + Vector.new(2, 2)

    @speed = Configuration::INITIAL_SPEED
    @timer = Timer.new(@speed)

    @board = Board.new(board_size.x, board_size.y)

    init_curses(screen_size)
  end

  def run
    @shape = Shape.new(Vector.new(5, 0), [[1, 1, 1, 1]])
    # shape = Shape.new(Vector.new(5, 5), [[1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])

    @timer.start

    loop do
      @win.clear

      @win.box('|', '-')
      @win.addstr('Tetris')

      # draw the board
      @board.height.times do |y|
        @board.width.times do |x|
          if @board.cell_occupied?(x, y)
            @win.setpos(y + 1, x + 1)
            @win.addch(Configuration::RENDER_CHARACTER)
          end
        end
      end

      # draw the shape
      @shape.layout.each_with_index do |row, row_index|
        row.each_with_index do |cell, column_index|
          # check if the cell is occupied
          if cell != 0
            # Get the absolute position of the cell in the board
            x = @shape.position.x + column_index
            y = @shape.position.y + row_index

            @win.setpos(y + 1, x + 1) # Corrected order of arguments
            @win.addch(Configuration::RENDER_CHARACTER)
          end
        end
      end

      #print_debug

      shape_fall(@shape)

      case @win.getch
      when 'w'
        #move_shape(Direction::TOP)
        rotate_shape
      when 's'
        move_shape(Direction::BOTTOM)
      when 'a'
        move_shape(Direction::LEFT)
      when 'd'
        move_shape(Direction::RIGHT)
      when 'r'
        rotate_shape
      when 'q'
        break
      end
    end

    Curses.close_screen
  end

  def move_shape( direction)
    if @board.can_move?(@shape, direction)
      @shape.move!(direction)
    end
  end

  def rotate_shape
    if @board.can_rotate?(@shape)
      @shape.rotate!
    end
  end

  def shape_fall(shape)
    if @timer.tick?
      @timer.update_wait_time(@speed)
      @timer.reset

      moved_shape = shape.move(Direction::BOTTOM)
      if @board.is_colliding?(moved_shape)
        @board.add_shape(shape)
        spawn_shape
      else
        shape.move!(Direction::BOTTOM)
      end
    end
  end

  def spawn_shape()
    @shape = Shape.random_shape(Vector.new(10, 0))
    if @board.is_colliding?(@shape)
      # game over
      @win.setpos(10, 1)
      @win.addstr("Game Over")
    end
  end

  def print_debug
    @win.setpos(15, 1)
    @win.addstr("Speed: #{@speed}")
    @win.setpos(17, 1)
    @win.addstr(@timer.elapsed_time.to_s)

    @win.setpos(1, 25)
    @win.addstr("Shape position")
  end
end

Tetris.new.run
