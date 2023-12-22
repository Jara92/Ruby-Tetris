require_relative 'screen'
require_relative 'score_manager'
require_relative 'game_screen'
require_relative 'controls_screen'

class MenuScreen < Screen

  MENU_OPTIONS = [
    { "title" => "Start Game", "action" => :start_game },
    { "title" => "Constrols", "action" => :controls },
    { "title" => "Exit", "action" => :exit },
  ]

  def initialize(window, colors)
    super

    @score_manager = ScoreManager.instance
    @exit = false
    @active_option = 0
  end

  def run
    until @exit
      handle_menu_input

      super

      render_constrols

    end
  end

  private

  def handle_menu_input
    case @win.getch
    when 's'
      next_option
    when 'w'
      previous_option
    when 10 # Enter
      perform_menu_option
    when 'q'
      exit
    else
      # todo
    end
  end

  def next_option
    @active_option = (@active_option + 1) % MENU_OPTIONS.length
  end

  def previous_option
    @active_option = (@active_option - 1) % MENU_OPTIONS.length
  end

  def perform_menu_option
    case MENU_OPTIONS[@active_option]["action"]
    when :start_game
      start_game
    when :controls
      controls
    when :exit
      exit
    else
      # nothing
    end
  end

  def start_game
    # Open new game screen
    game_screen = GameScreen.new(@win, @colors)
    game_screen.run

    # fixme: score is not updating
  end

  def controls
    controls_screen = ControlsScreen.new(@win, @colors)
    controls_screen.run
  end

  def render_constrols
    render_top_score
    render_menu_options
  end

  def render_top_score
    change_color(:green_black)

    score_text = "Top Score: #{ScoreManager.instance.get_top_score}"
    @win.setpos(2, Configuration::SCREEN_PADDING_LEFT + Configuration::BOARD_WIDTH / 2 - score_text.length / 2)
    @win.addstr(score_text)

    change_color(:white_black)
  end

  def render_menu_options
    MENU_OPTIONS.each_with_index do |option, index|
      # Active menu item color
      change_color(:red_black) if index == @active_option

      @win.setpos(5 + index, Configuration::SCREEN_PADDING_LEFT + Configuration::BOARD_WIDTH / 2 - option["title"].length / 2)
      @win.addstr(option["title"])

      change_color(:white_black) if index == @active_option
    end
  end
end
