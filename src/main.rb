require 'curses'
require_relative 'direction'
require_relative 'configuration'
require_relative 'game_manager'

include Curses

class Tetris

  def init_curses
    Curses.init_screen
    Curses.curs_set(0) # Hide the cursor
    @win = Curses::Window.new(Configuration::SCREEN_HEIGHT, Configuration::SCREEN_WIDTH, 0, 0) # height comes first
    @win.timeout = 100 # Set a timeout for getch in milliseconds
    @win.box('|', '-')
    @win.addstr(Configuration::TITLE)

    init_colors

    @win.refresh
  end

  def close_curses
    Curses.close_screen
  end

  def init_colors()
    Curses.start_color
    @colors = {}

    # For each definition create color pair with index as id
    [
      [:white_black, Curses::COLOR_WHITE, Curses::COLOR_BLACK],
      [:red_black, Curses::COLOR_RED, Curses::COLOR_BLACK],
      [:green_black, Curses::COLOR_GREEN, Curses::COLOR_BLACK],
    ].each_with_index do |(name, fg, bg), index|
      id = index + 1
      Curses.init_pair(id, fg, bg)
      @colors[name] = id
    end
  end

  def change_color(name)
    raise "Color #{name} not defined" unless @colors[name]

    @win.color_set(@colors[name])
  end

  def initialize
    @game_manager = GameManager.new

    init_curses
  end

  def run
    @game_manager.start

    while @game_manager.running
      # Handle input and update the game
      handle_input
      @game_manager.update

      # Clear the screen and prepare for rendering
      @win.clear

      @win.box('|', '-')
      @win.addstr(Configuration::TITLE)

      render_board(@game_manager.board)
      render_shape(@game_manager.shape)
      # render_panel

      if @game_manager.paused?
        change_color(:red_black)
        @win.setpos(@game_manager.board.height / 2, @game_manager.board.width / 2 - 2)
        @win.addstr("PAUSED")
        change_color(:white_black)
      end

      #render_debug
    end

    close_curses
  end

  def handle_input
    case @win.getch
    when 'w'
      # move_shape(Direction::TOP)
      @game_manager.rotate_shape
    when 's'
      @game_manager.move_shape(Direction::BOTTOM)
    when 'a'
      @game_manager.move_shape(Direction::LEFT)
    when 'd'
      @game_manager.move_shape(Direction::RIGHT)
    when 'r'
      @game_manager.rotate_shape
    when 'p'
      @game_manager.toggle_pause
    when 'q'
      @game_manager.exit
    else
      # Nothing
    end
  end

  def render_shape(shape)
    shape.layout.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        # check if the cell is occupied
        if cell != 0
          # Get the absolute position of the cell in the board
          x = shape.position.x + column_index
          y = shape.position.y + row_index

          @win.setpos(y + 1, x + 1) # Corrected order of arguments
          @win.addch(Configuration::RENDER_CHARACTER)
        end
      end
    end
  end

  def render_board(board)
    board.height.times do |y|
      board.width.times do |x|
        if board.cell_occupied?(x, y)
          @win.setpos(y + 1, x + 1)
          @win.addch(Configuration::RENDER_CHARACTER)
        end
      end
    end
  end

  def render_panel
    @win.setpos(24, 1)
    change_color(:green_black)
    @win.addstr("Score: #{@game_manager.score}")
    change_color(:white_black)
  end

  def render_debug
    @win.setpos(15, 1)
    @win.addstr("Speed: #{@speed}")
    @win.setpos(17, 1)
    @win.addstr(@game_manager.timer.elapsed_time.to_s)

    @win.setpos(1, 25)
    @win.addstr("Shape position")
  end
end

Tetris.new.run
