class Game < ActiveRecord::Base

  serialize :moves

  has_many :plays
  has_many :players, through: :plays, source: :user
  belongs_to :winner, class_name: 'User', foreign_key: :user_id

  # validate_on_create :players_count_within_bounds

  private

    def players_count_within_bounds
      return if players.blank?
      errors.add("Game already has two players!") if players.size >= 2
    end

end