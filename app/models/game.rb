class Game < ActiveRecord::Base

  serialize :moves

  has_many :plays
  has_many :players, through: :plays, source: :user
  belongs_to :winner, class_name: 'User', foreign_key: :user_id

end