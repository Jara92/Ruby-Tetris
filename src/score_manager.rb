require 'singleton'

"" "
Score manager for the game
Saved and manages the top score of the game
" ""
class ScoreManager
  # There is only one instance of the score manager
  include Singleton

  def initialize(filename = "data/top_score.txt")
    @filename = filename

    # Load the top score from the file
    load_top_score
  end

  def get_top_score
    @top_score
  end

  "" "
  Save the top score to the file
  " ""
  def save_top_score(score)
    @top_score = score
    File.write(@filename, score)
  end

  private

  "" "
  Load the top score from the file
  " ""
  def load_top_score
    # Load the top score from the file if it exists
    if File.exist?(@filename)
      @top_score = File.read(@filename).to_i
    end

    # Set the top score to 0 if it is not set
    @top_score ||= 0
  end

end