require 'curses'
require_relative 'shape'
require_relative 'direction'
require_relative 'board'

include Curses

class Tetris
  def initialize

    board_size = Vector.new(20, 25)
    screen_size = board_size + Vector.new(2, 2)

    @board = Board.new(board_size.x, board_size.y, [
      Vector.new(0, 0),
      Vector.new(1, 0),
      Vector.new(0, 1),

      Vector.new(18, 0),
      Vector.new(19, 0),
      Vector.new(19, 1),

      Vector.new(5, 4),
      Vector.new(4, 5),
      Vector.new(5, 5),
      Vector.new(6, 5),
      Vector.new(5, 6)
    ])

    Curses.init_screen
    Curses.curs_set(0) # Hide the cursor
    #@win = Curses.stdscr
    @win = Curses::Window.new(screen_size.y, screen_size.x, 0, 0)
    @win.timeout = 100 # Set a timeout for getch in milliseconds
    @win.box('|', '-')
    @win.addstr('Tetris')
    @win.refresh
    return

    Curses.noecho
    Curses.cbreak
    @win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
    @win.keypad = true
    @win.timeout = 100
    @win.nodelay = true
    @win.box('|', '-')
    @win.setpos(0, 2)
    @win.addstr('Tetris')
    @win.refresh
  end

  def run
    shape = Shape.new(Vector.new(0, 0), [[1, 1, 1, 1]])
    # shape = Shape.new(Vector.new(5, 5), [[1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])

    loop do
      @win.clear

      @win.box('|', '-')
      @win.addstr('Tetris')

      #draw the board
      @board.height.times do |y|
        @board.width.times do |x|
          if @board.cell_occupied?(x, y)
            @win.setpos(y + 1, x + 1)
            @win.addch('O')
          end

          #@win.setpos(y + 1, x + 1)
          #@win.addch(@board.get_cell(x, y) == 1 ? 'O' : ' ')
        end
      end

      # draw the shape
      shape.layout.each_with_index do |row, row_index|
        row.each_with_index do |cell, column_index|
          # check if the cell is occupied
          if cell != 0
            # Get the absolute position of the cell in the board
            x = shape.position.x + column_index
            y = shape.position.y + row_index

            @win.setpos(y + 1, x + 1) # Corrected order of arguments
            @win.addch('O')
          end
        end
      end

      case @win.getch
      when 'w'
        shape.move!(Direction::TOP)
      when 's'
        shape.move!(Direction::BOTTOM)
      when 'a'
        shape.move!(Direction::LEFT)
      when 'd'
        shape.move!(Direction::RIGHT)
      when 'r'
        shape.rotate!
      when 'q'
        break
      end
    end

    Curses.close_screen
  end
end

Tetris.new.run
