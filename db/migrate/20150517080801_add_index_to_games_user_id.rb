class AddIndexToGamesUserId < ActiveRecord::Migration

  def change
    add_index :games, :user_id
  end

end