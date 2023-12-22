require_relative 'screen'

class ControlsScreen < Screen

  CONTROLS = [
    { "key" => "W", "title" => "Rotate" },
    { "key" => "A", "title" => "Move left" },
    { "key" => "D", "title" => "Move right" },
    { "key" => "S", "title" => "Fall faster" },
    { "key" => "P", "title" => "Pause" },
    { "key" => "Q", "title" => "Quit game" },
  ]

  def initialize(window, colors)
    super
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
    when 'q'
      exit
    else
      # todo
    end
  end

  def render_constrols
    # display title
    title = "Controls"
    @win.setpos(2, Configuration::SCREEN_PADDING_LEFT + Configuration::BOARD_WIDTH / 2 - title.length / 2)
    @win.addstr(title)

    # display controls
    CONTROLS.each_with_index do |control, index|
      text = "#{control["key"]}: #{control["title"]}"
      @win.setpos(4 + index, Configuration::SCREEN_PADDING_LEFT + 2)
      @win.addstr(text)
    end

    # back to menu
    text = "Press Q to leave"
    @win.setpos(Configuration::BOARD_HEIGHT + Configuration::SCREEN_PADDING_TOP - 2, Configuration::SCREEN_PADDING_LEFT + 2)
    @win.addstr(text)
  end

end
