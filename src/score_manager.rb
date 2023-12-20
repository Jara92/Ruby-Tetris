require 'singleton'

class ScoreManager
  include Singleton

  def initialize(filename = "data/top_score.txt")
    @filename = filename

    load_top_score

  end

  def get_top_score
    @top_score
  end

  def save_top_score(score)
    File.write(@filename, score)
  end

  private

  def load_top_score
    if File.exist?(@filename)
      @top_score = File.read(@filename).to_i
    end

    @top_score ||= 0
  end

end