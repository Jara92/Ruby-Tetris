=begin
The Tetris game configuration
=end
module Configuration
  # Game screen title
  TITLE = 'Tetris'

  # Board size
  BOARD_WIDTH = 20
  BOARD_HEIGHT = 20

  # Padding between sreen and the game board
  SCREEN_PADDING_TOP = 4
  SCREEN_PADDING_LEFT = 1

  # Screen size
  SCREEN_WIDTH = BOARD_WIDTH + SCREEN_PADDING_LEFT + 1
  SCREEN_HEIGHT = BOARD_HEIGHT + SCREEN_PADDING_TOP + 1

  # ASCII cahracter to be used for rendering game objects
  # RENDER_CHARACTER = 'o'
  RENDER_CHARACTER = '#'

  # Box rendering characters
  BOX_VERTICAL = '|'
  BOX_HORIZONTAL = '-'

  # Gameplay configuration
  FIRST_LEVEL_UP_SCORE = 5 # Score needed to reach level 2
  SCORE_NEXT_LEVEL_FACTOR = 1.5 # Score for level n = FIRST_LEVEL_UP_SCORE * SCORE_NEXT_LEVEL_FACTOR^(n-2), n >= 2
  INITIAL_SPEED = 0.4 # shape fall every 0.4 seconds
  FALLING_SPEED_FACTOR = 0.95 # 5% faster every level
  SPEEDUP_FACTOR = 1.5 # 50% faster when speedup
end