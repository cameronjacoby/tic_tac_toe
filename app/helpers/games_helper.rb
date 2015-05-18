module GamesHelper

  def last_play user
    user.games.last.created_at.in_time_zone('Pacific Time (US & Canada)').to_formatted_s(:long)
  end

end