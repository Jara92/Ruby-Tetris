require_relative 'configuration'
require_relative 'game_manager'

=begin
Base class for all screens
=end
class Screen
  def initialize(window, colors)
    @win = window
    @colors = colors

    # Set the exit flag to false
    @exit = false
  end

  def run
    clear_screen
  end

  protected

  def exit
    @exit = true
  end

  "" "
  Clear the screen, render the title and the box and prepare for rendering
  " ""
  def clear_screen
    # Clear the screen and prepare for rendering
    @win.clear

    @win.box(Configuration::BOX_VERTICAL, Configuration::BOX_HORIZONTAL)
    @win.addstr(Configuration::TITLE)
  end

  "" "
  Change current text color
  " ""
  def change_color(name)
    raise "Color #{name} not defined" unless @colors[name]

    @win.color_set(@colors[name])
  end
end