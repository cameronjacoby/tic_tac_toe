class RenameTicTacToeGamesToGames < ActiveRecord::Migration

  def change
    rename_table :tic_tac_toe_games, :games
  end

end