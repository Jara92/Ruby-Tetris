require 'curses'
require_relative 'configuration'
require_relative 'menu_screen'

include Curses

class Tetris

  def initialize
    init_curses
  end

  def init_curses
    Curses.init_screen
    Curses.curs_set(0) # Hide the cursor
    @win = Curses::Window.new(Configuration::SCREEN_HEIGHT, Configuration::SCREEN_WIDTH, 0, 0) # height comes first
    @win.timeout = 100 # Set a timeout for getch in milliseconds

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

  def run
    # screen = GameScreen.new(@win, @colors)
    screen = MenuScreen.new(@win, @colors)
    screen.run

    close_curses
  end

end

Tetris.new.run
