class Game < ActiveRecord::Base

  serialize :moves

  has_many :plays
  has_many :players, through: :plays, source: :user
  belongs_to :winner, class_name: 'User', foreign_key: :user_id

  validate :players_count

  DEFAULT_BOARD_SIZE = 3

  scope :one_player, lambda { joins(:plays).group("games.id").having("count(*) = ?", 1) }

  def create_board
    self.moves = Array.new(board_size * board_size)
  end

  def get_winner
    player_indexes = moves.uniq
    top_left = 0
    top_right = board_size - 1
    bottom_left = board_size * (board_size - 1)
    bottom_right = board_size * board_size - 1

    player_indexes.each do |index|

      # horizontal wins
      (top_left..bottom_left).step(board_size) do |board_position|
        ending_board_position = board_position + board_size - 1
        if winner = check_win(board_size, index, board_position, ending_board_position, :horizontal)
          return winner
        end
      end

      # vertical wins
      (top_left..top_right).each do |board_position|
        ending_board_position = board_position + (board_size * (board_size - 1))
        if winner = check_win(board_size, index, board_position, ending_board_position, :vertical)
          return winner
        end
      end

      # diagonal win (from top left)
      if winner = check_win(board_size, index, top_left, bottom_right, :diagonal_left)
        return winner
      end

      # diagonal win (from top right)
      if winner = check_win(board_size, index, top_right, bottom_left, :diagonal_right)
        return winner
      end
    end
    return nil
  end

  private

    def players_count
      if players.size > 2
        errors[:base] << "Game already has two players!"
      end
    end

    def check_win bd_size, pl_index, current_pos, ending_pos, direction
      if current_pos <= ending_pos
        if moves[current_pos] == pl_index
          if current_pos == ending_pos
            return players.by_plays[pl_index]
          else
            current_pos = increment_board_pos(bd_size, current_pos, direction)
            check_win(bd_size, pl_index, current_pos, ending_pos, direction)
          end
        end
      end
    end

    def increment_board_pos bd_size, current_pos, direction
      case direction
        when :horizontal then current_pos + 1
        when :vertical then current_pos + bd_size
        when :diagonal_left then current_pos + bd_size + 1
        when :diagonal_right then current_pos + bd_size - 1
      end
    end

end