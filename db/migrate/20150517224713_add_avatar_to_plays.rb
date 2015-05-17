class AddAvatarToPlays < ActiveRecord::Migration
  
  def change
    add_column :plays, :avatar, :string
  end

end