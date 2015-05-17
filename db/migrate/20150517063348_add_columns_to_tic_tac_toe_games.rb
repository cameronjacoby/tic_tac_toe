class AddColumnsToTicTacToeGames < ActiveRecord::Migration

  def change
    add_column :tic_tac_toe_games, :board_size, :integer
    add_column :tic_tac_toe_games, :winner_id, :integer
    add_index :tic_tac_toe_games, :winner_id
  end

end