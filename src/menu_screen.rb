require_relative 'screen'
require_relative 'score_manager'
require_relative 'game_screen'
require_relative 'controls_screen'

=begin
Menu screen for the game
=end
class MenuScreen < Screen

  MENU_OPTIONS = [
    { "title" => "Start Game", "action" => :start_game },
    { "title" => "Controls", "action" => :controls },
    { "title" => "Exit", "action" => :exit },
  ]

  def initialize(window, colors)
    super

    # Get the score manager instance
    @score_manager = ScoreManager.instance

    # Set the active menu option
    @active_option = 0
  end

  "" "
  Run the menu screen loop
  " ""
  def run
    until @exit
      # handle input and refresh the screen
      handle_menu_input
      super

      # render the menu
      render_menu

    end
  end

  private

  "" "
  Handle menu input
  " ""
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

  "" "
  Move the active menu option down
  " ""
  def next_option
    @active_option = (@active_option + 1) % MENU_OPTIONS.length
  end

  "" "
  Move the active menu option up
  " ""
  def previous_option
    @active_option = (@active_option - 1) % MENU_OPTIONS.length
  end

  "" "
  Perform the action of the active menu option
  " ""
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

  "" "
  Start a new game
  " ""
  def start_game
    # Open new game screen
    game_screen = GameScreen.new(@win, @colors)
    game_screen.run
  end

  "" "
  Open the controls screen
  " ""
  def controls
    controls_screen = ControlsScreen.new(@win, @colors)
    controls_screen.run
  end

  "" "
  Render the menu screen
  " ""

  def render_menu
    render_top_score
    render_menu_options
  end

  "" "
  Render the top score
  " ""
  def render_top_score
    change_color(:green_black)

    score_text = "Top Score: #{ScoreManager.instance.get_top_score}"
    @win.setpos(2, Configuration::SCREEN_PADDING_LEFT + Configuration::BOARD_WIDTH / 2 - score_text.length / 2)
    @win.addstr(score_text)

    change_color(:white_black)
  end

  "" "
  Render the menu options
  " ""
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
