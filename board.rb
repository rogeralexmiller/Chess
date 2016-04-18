require_relative 'piece'

class Board

  def initialize
    @grid = Array.new(8) {Array.new(8,nil)}
    setup_board
  end

  def setup_board
    @grid[0..1].each_with_index do |row, row_idx|
      row.each_with_index do |space, col_idx|
        pos = [row_idx,col_idx]
        self[pos] = Piece.new(self,"black",pos)
      end
    end

    @grid[-2..-1].each_with_index do |row, row_idx|
      row.each_with_index do |space, col_idx|
        pos = [row_idx,col_idx]
        self[pos] = Piece.new(self,"white",pos)
      end
    end

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

end

board = Board.new
rook = Rook.new(board, :white, [4,4])
board[ [4,4] ] = rook
# p bishop
p rook.moves
