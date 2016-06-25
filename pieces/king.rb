require_relative 'stepping_piece'

class King < SteppingPiece

  attr_reader :moved

  def initialize
    @moved = false
  end

  # castling:
  # Castling may only be done if the king has never moved, the rook involved has
  # never moved, the squares between the king and the rook involved are unoccupied,
  # the king is not in check, and the king does not cross over or end on a square
  # in which it would be in check.

  # 1. check if king has ever moved. store as a boolean. done
  # 2. check if castles have ever moved. store as a boolean. done
  # 3. check if squares between king and rook are unoccupied. 3 on queen side. 2 on kingside
  # 4. check if any of those squares are in check.
  # 5. If all of these conditions are met, show the castle as a potential_move.


  def can_castle?
    return false if moved
    return false if castle_moved
  end

  def moves
    moves_helper(SteppingPiece::DELTAS.values)
  end

  def to_s
    @color == :white ? "♔" : "♚"
  end
end
