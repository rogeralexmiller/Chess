require_relative 'stepping_piece'

class Knight < SteppingPiece

  MOVES = [
    Piece.add_positions(DELTAS[:up], DELTAS[:up], DELTAS[:right]),
    Piece.add_positions(DELTAS[:up], DELTAS[:up], DELTAS[:left]),
    Piece.add_positions(DELTAS[:up], DELTAS[:left], DELTAS[:left]),
    Piece.add_positions(DELTAS[:up], DELTAS[:right], DELTAS[:right]),

    Piece.add_positions(DELTAS[:down], DELTAS[:right], DELTAS[:right]),
    Piece.add_positions(DELTAS[:down], DELTAS[:left], DELTAS[:left]),
    Piece.add_positions(DELTAS[:down], DELTAS[:down], DELTAS[:right]),
    Piece.add_positions(DELTAS[:down], DELTAS[:down], DELTAS[:left])
  ]

  def moves
    moves_helper(Knight::MOVES)
  end

  def to_s
    "♘"
  end
end
