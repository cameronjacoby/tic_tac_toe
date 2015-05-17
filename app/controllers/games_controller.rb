class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]

  def create
    if Game.one_player.any?
      @game = Game.one_player.first
    else
      @game = Game.new(board_size: Game::DEFAULT_BOARD_SIZE)
      @game.create_board
    end
    @game.players << current_user
    if @game.save
      redirect_to game_path(@game)
    else
      redirect_to root_path
    end
  end

  def show
  end

  private

    def set_game
      @game = Game.find(params[:id])
    end

end