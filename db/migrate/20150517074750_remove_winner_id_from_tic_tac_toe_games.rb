class RemoveWinnerIdFromTicTacToeGames < ActiveRecord::Migration

  def change
    remove_column :tic_tac_toe_games, :winner_id, :integer
  end

end