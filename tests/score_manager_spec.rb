# my_class_spec.rb
require 'rspec'
require_relative '../src/score_manager'

describe ScoreManager do

  TEST_FILE = 'data/test_top_score.txt'

  describe "Get the score" do
    it "get the top score" do
      # write the file
      File.write(TEST_FILE, 100)

      score_manager = ScoreManager.instance
      score_manager.change_file_name!(TEST_FILE)

      # The top score is 0
      expect(score_manager.get_top_score).to eq(100)

      # delete the file
      File.delete(TEST_FILE)
    end
  end

  describe 'update the score' do
    it 'update the score' do
      score_manager = ScoreManager.instance
      score_manager.change_file_name!(TEST_FILE)

      # The top score is 0
      expect(score_manager.get_top_score).to eq(0)

      # Update the top score
      score_manager.save_top_score(100)

      # the top score is 100
      expect(score_manager.get_top_score).to eq(100)

      # Check that the file was updated
      score_manager.change_file_name!(TEST_FILE)
      expect(score_manager.get_top_score).to eq(100)

      # delete the file
      File.delete(TEST_FILE)
    end
  end

  it 'two instances' do
    score_manager = ScoreManager.instance
    score_manager.change_file_name!(TEST_FILE)

    score_manager2 = ScoreManager.instance
    score_manager2.change_file_name!(TEST_FILE)

    score_manager.save_top_score(100)

    # second score manager should have the same top score
    expect(score_manager2.get_top_score).to eq(score_manager.get_top_score)

    # delete the file
    File.delete(TEST_FILE)
  end
end
