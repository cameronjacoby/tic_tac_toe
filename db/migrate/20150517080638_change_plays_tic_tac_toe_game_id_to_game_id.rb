class ChangePlaysTicTacToeGameIdToGameId < ActiveRecord::Migration

  def change
    rename_column :plays, :tic_tac_toe_game_id, :game_id
  end

end