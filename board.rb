require_relative 'piece'
require 'byebug'

class Board

  def initialize
    @grid = Array.new(8) {Array.new(8,nil)}
    setup_board
  end

  def setup_board
    place_pawns
    place_minor_pieces
    place_major_pieces
  end

  def place_pawns
    [@grid[1], @grid[6]].each_with_index do |row, color|
      row.each_with_index do |space, col_idx|
        # debugger
        row_idx = color == 0 ? 1 : 6
        pos = [row_idx, col_idx]
        piece_color = color == 0 ? :black : :white
        self[pos] = Pawn.new(self, piece_color, pos)
      end
    end
  end

  def place_minor_pieces
    [Rook, Knight, Bishop].each_with_index do |piece_class, i|
      white_left = [7,i]
      white_right = [7,7-i]
      black_left = [0,i]
      black_right = [0,7-i]

      self[white_left] = piece_class.new(self, :white, white_left)
      self[white_right] = piece_class.new(self, :white, white_right)
      self[black_left] = piece_class.new(self, :black, black_left)
      self[black_right] = piece_class.new(self, :black, black_right)
    end
  end

  def place_major_pieces
    black_king_pos = [0, 4]
    black_queen_pos = [0, 3]
    white_king_pos = [7, 4]
    white_queen_pos = [7, 3]
    self[black_king_pos] = King.new(self, :black, black_king_pos)
    self[black_queen_pos] = Queen.new(self, :black, black_queen_pos)
    self[white_king_pos] = King.new(self, :white, white_king_pos)
    self[white_queen_pos] = Queen.new(self, :white, white_queen_pos)
  end

  def show_board
    @grid.each do |row|
      puts row.join(' ')
    end
  end

  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos[0], pos[1]
    @grid[row][col] = value
  end

  def move(start_pos, end_pos)
    raise "No piece at #{start_pos}" unless self[start_pos]
    unless self[end_pos].nil? || self[end_pos].color == self[start_pos].nil?
      raise "That's not a valid space to move to"
    end
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def piece_here(pos)
    self[pos]
  end

end

board = Board.new
board.show_board
