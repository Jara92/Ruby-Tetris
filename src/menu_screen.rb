require_relative 'screen'

class MenuScreen < Screen
  def initialize(window, colors)
    super

    @exit = false
  end

  def run
    until @exit
      handle_menu_input

      super

      render_menu

    end
  end

  private

  def handle_menu_input
    case @win.getch
    when 's'
      start_game
    when 'q'
      exit_game
    else
      # todo
    end
  end

  def start_game
    # Open new game screen
    game_screen = GameScreen.new(@win, @colors)
    game_screen.run
  end

  def exit_game
    @exit = true
  end

  def render_menu
    render_top_score
    render_menu_options
  end

  def render_top_score
    # todo
  end

  def render_menu_options
    [
      "S. Start Game",
      "Q. Exit"
    ].each_with_index do |option, index|
      @win.setpos(5 + index, Configuration::SCREEN_PADDING_LEFT + 2)
      @win.addstr(option)
    end
  end
end
