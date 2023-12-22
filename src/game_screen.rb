require_relative 'screen'

class GameScreen < Screen
  def initialize(window, colors)
    super

    @game_manager = GameManager.new
  end

  def run
    @game_manager.start

    while @game_manager.running?
      # Handle input and update the game
      handle_input
      @game_manager.update

      # Clear the screen and prepare for rendering
      super

      render_board(@game_manager.board)
      render_shape(@game_manager.shape)
      render_panel

      if @game_manager.paused?
        render_middle_screen_message("PAUSED", :red_black)
      end

      if @game_manager.game_over?
        render_game_over
      end

      # render_debug
    end
  end

  private
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
    when 'p'
      @game_manager.toggle_pause
    when 'q'
      @game_manager.exit
      # Cheat engine
    when 'o'
      @game_manager.add_score(1)
    when 'l'
      @game_manager.add_score(-1)
    when 'r'
      restart_game
    else
      # Nothing
    end
  end

  def restart_game
    @game_manager = GameManager.new
    @game_manager.start
  end

  def render_shape(shape)
    shape.layout.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        # check if the cell is occupied
        if cell != 0
          # Get the absolute position of the cell in the board
          x = shape.position.x + column_index
          y = shape.position.y + row_index

          @win.setpos(y + Configuration::SCREEN_PADDING_TOP, x + Configuration::SCREEN_PADDING_LEFT) # Corrected order of arguments
          @win.addch(Configuration::RENDER_CHARACTER)
        end
      end
    end
  end

  def render_board(board)
    board.height.times do |y|
      board.width.times do |x|
        if board.cell_occupied?(x, y)
          @win.setpos(y + Configuration::SCREEN_PADDING_TOP, x + Configuration::SCREEN_PADDING_LEFT)
          @win.addch(Configuration::RENDER_CHARACTER)
        end
      end
    end
  end

  def render_panel
    change_color(:green_black)
    @win.setpos(1, 2)
    @win.addstr("Score: #{@game_manager.score}")

    @win.setpos(2, 2)
    @win.addstr("Level: #{@game_manager.level}")

    change_color(:white_black)

    # render horizontal line
    (1..Configuration::SCREEN_WIDTH - Configuration::SCREEN_PADDING_LEFT - 1).each do |col|
      @win.setpos(Configuration::SCREEN_PADDING_TOP - 1, col)
      @win.addch(Configuration::BOX_HORIZONTAL)
    end
  end

  def render_middle_screen_message(message, color = :white_black, x = nil, y = nil)
    raise TypeError, "Message must be a string" unless message.is_a? String

    x ||= Configuration::SCREEN_HEIGHT / 2
    y ||= Configuration::SCREEN_WIDTH / 2 - message.length / 2

    change_color(color)
    @win.setpos(x, y)
    @win.addstr(message)

    # Reset color
    change_color(:white_black)
  end

  def render_game_over
    # display game over message in the middle of the screen
    render_middle_screen_message("GAME OVER", :red_black)

    # display options in the middle of the screen below the game over message
    render_middle_screen_message("Press R to restart", :green_black, y = Configuration::SCREEN_HEIGHT / 2 + 2)
    render_middle_screen_message("Press Q to quit", :green_black, y = Configuration::SCREEN_HEIGHT / 2 + 3)
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