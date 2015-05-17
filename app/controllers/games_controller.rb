class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]

  def create
    @game = Game.new(board_size: Game::DEFAULT_BOARD_SIZE)
    @game.create_board
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