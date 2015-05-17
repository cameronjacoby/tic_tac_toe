class CreateTicTacToeGames < ActiveRecord::Migration
  
  def change
    create_table :tic_tac_toe_games do |t|
      t.string :moves
      t.timestamps
    end
  end

end