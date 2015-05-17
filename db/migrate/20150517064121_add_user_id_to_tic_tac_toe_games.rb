class AddUserIdToTicTacToeGames < ActiveRecord::Migration

  def change
    add_column :tic_tac_toe_games, :user_id, :integer
  end

end