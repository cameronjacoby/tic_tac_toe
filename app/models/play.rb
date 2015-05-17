class Play < ActiveRecord::Base

  belongs_to :user
  belongs_to :tic_tac_toe_game

end