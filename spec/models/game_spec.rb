require 'rails_helper'

describe Game do
  let(:game) { FactoryGirl.create(:game) }
    
  before do
    game.create_board
  end

  describe '#get_turn' do
    it "should return player 0 if there are no moves yet" do
      expect(game.get_turn).to eq(0)
    end

    it "should return player with least number of turns so far" do
      game.moves = [0, 0, 1, 0, 1, nil, nil, nil, nil]
      game.save!
      expect(game.get_turn).to eq(1)
    end
  end

  describe '#get_winner' do
    it "should return nil if there is no winner" do
      game.moves = [0, 0, 1, 1, 1, 0, 0, 1, 0]
      game.save!
      expect(game.get_winner).to eq(nil)
    end

    it "should calculate horizontal wins" do
      game.moves = [0, 0, 0, 1, 1, 0, 0, 1, 1]
      game.save!
      expect(game.get_winner).to eq(0)
    end

    it "should calculate vertical wins" do
      game.moves = [1, 0, 1, 1, 0, 0, 1, 1, 0]
      game.save!
      expect(game.get_winner).to eq(1)
    end

    it "should calculate diagonal wins" do
      game.moves = [0, 1, 1, 1, 0, 0, 0, 1, 0]
      game.save!
      expect(game.get_winner).to eq(0)
    end

    it "should calculate win on any size board" do
      game.board_size = 5
      game.moves = [ 0, 0, 1, 1, 1,
                     1, 0, 0, 1, 0,
                     0, 1, 1, 1, 0,
                     0, 1, 0, 1, 0,
                     1, 0, 1, 0, 1 ]
      game.save!
      expect(game.get_winner).to eq(1)
    end
  end

end