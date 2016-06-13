require_relative 'pieces/pawn'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/rook'

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
    if self.piece_here(end_pos) && self[end_pos].color == self[start_pos].color
      raise "That's not a valid space to move to"
    end

    self[end_pos] = self[start_pos]

    # Moved piece is now at self[end_pos]
    self[end_pos].pos = end_pos
    self[end_pos].moved = true
    self[start_pos] = nil
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def piece_here(pos)
    self[pos]
  end

  def under_threat?(pos, color)
    opponent_color = color == :white ? :black : :white
    opponent_pieces = get_pieces(opponent_color)
    opponent_pieces.any? do |piece|
      piece_moves = piece.moves
      piece_moves.include?(pos)
    end
  end

  def in_check?(color)
    king = get_pieces(color).select { |piece| piece.is_a?(King) }.first
    under_threat?(king.pos, king.color)
  end

  def get_pieces(color)
    pieces = []
    @grid.each do |row|
      row.each do |space|
        pieces << space if space && space.color == color
      end
    end
    pieces
  end

  def checkmate?(color)
    return false unless in_check?(color)
    get_pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def dup
    new_board = Board.new

    @grid.each_with_index do |row, row_index|
      row.each_with_index do |space, col_index|
        pos = [row_index, col_index]
        if self[pos]
          color = self[pos].color
          piece_class = self[pos].class
          new_board[pos] = piece_class.new(new_board, color, pos)
        else
          new_board[pos] = nil
        end
      end
    end
    new_board
  end

  def move_into_checkmate
    move([6, 5], [5, 5])
    move([1, 4], [3, 4])
    move([6, 6], [4, 6])
    move([0, 3], [4, 7])
  end

  protected
  attr_accessor :grid
end

# board = Board.new
# board.move_into_checkmate
# # king = board[[7,4]]
# # p board.in_check?(:white)
# # p king.valid_moves
# board.show_board
