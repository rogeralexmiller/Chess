require_relative 'stepping_piece'

class King < SteppingPiece
  # Account for moving into check
  def moves
    moves_helper(SteppingPiece::DELTAS.values)
  end

  def to_s
    "♔"
  end
end
