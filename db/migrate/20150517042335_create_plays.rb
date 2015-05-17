class CreatePlays < ActiveRecord::Migration
  
  def change
    create_table :plays do |t|
      t.references :user
      t.references :tic_tac_toe_game
      t.timestamps
    end
  end

end