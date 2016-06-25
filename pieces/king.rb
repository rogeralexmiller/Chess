require_relative 'stepping_piece'

class King < SteppingPiece

  attr_reader :moved

  def initialize
    @moved = false
  end

  def can_castle?
    
  end

  def moves
    moves_helper(SteppingPiece::DELTAS.values)
  end

  def to_s
    @color == :white ? "♔" : "♚"
  end
end
