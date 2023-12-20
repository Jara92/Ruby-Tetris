require_relative 'configuration'
require_relative 'game_manager'

class Screen
  def initialize(window, colors)
    @win = window
    @colors = colors

    @game_manager = GameManager.new

  end

  def run
    clear_screen
  end

  private

  def clear_screen
    # Clear the screen and prepare for rendering
    @win.clear

    @win.box(Configuration::BOX_VERTICAL, Configuration::BOX_HORIZONTAL)
    @win.addstr(Configuration::TITLE)

    #@win.refresh
  end

  def change_color(name)
    raise "Color #{name} not defined" unless @colors[name]

    @win.color_set(@colors[name])
  end
end