class Board

  def initialize
    @grid = Array.new(8) {Array.new(8,nil)}
    setup_board
  end

  def setup_board
    @grid[0..1].each do |row|
      row.map! {|space| Piece.new("black")}
    end

    @grid[-2..-1].each do |row|
      row.map! { |space| Piece.new("white") }
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

end

class Piece

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    @color[0]
  end

end

board = Board.new
board.show_board
