class Piece

  RENDER_COLOR = {
    :white => :green,
    :black => :light_red
  }

  attr_reader :color
  attr_accessor :pos, :moved

  def initialize(board, color, pos)
    @pos = pos
    @color = color
    @board = board
    @moved = false
  end

  def valid_moves
    moves.select do |move|
      board_dup = @board.dup
      board_dup.move(@pos, move)
      !board_dup.in_check?(@color)
    end
  end

  def self.add_positions(*positions)
    new_position = Array.new(2, 0)

    positions.each do |pos|
      new_position[0] += pos[0]
      new_position[1] += pos[1]
    end

    new_position
  end

  private
  attr_reader :board
end
