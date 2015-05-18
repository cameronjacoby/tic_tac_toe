class User < ActiveRecord::Base

  has_many :plays
  has_many :games, through: :plays
  has_many :games_won, class_name: 'Game'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  # preserves order of players joining the game
  scope :by_plays, lambda { includes(:plays).order("plays.created_at") }
  scope :winners, lambda { joins(:games_won).group("users.id").having("count(*) > ?", 0).order("count('users.games_won') desc") }

  def set_avatar! avatar, game
    plays.where(game: game).first.update_attributes(avatar: avatar)
  end

  def get_avatar game
    plays.where(game: game).first.avatar
  end

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

end