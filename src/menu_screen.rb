require_relative 'screen'
require_relative 'score_manager'
require_relative 'game_screen'

class MenuScreen < Screen
  def initialize(window, colors)
    super

    @score_manager = ScoreManager.instance
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

    # fixme: score is not updating
  end

  def exit_game
    @exit = true
  end

  def render_menu
    render_top_score
    render_menu_options
  end

  def render_top_score
    @win.setpos(2, Configuration::SCREEN_PADDING_LEFT + 2)
    @win.addstr("Top Score: #{@score_manager.get_top_score}")
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
