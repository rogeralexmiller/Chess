require_relative 'piece'

class SteppingPiece < Piece

  DELTAS = {
    :up => [-1, 0],
    :down => [1, 0],
    :left => [0, -1],
    :right => [0, 1],
    :upright => [-1, 1],
    :downright => [1, 1],
    :downleft => [1, -1],
    :upleft => [-1, -1]
  }

  def valid_step_move?(piece)
    piece.nil? || piece.color != self.color
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


  def moves_helper(deltas)
    moves = []
    deltas.each do |delta|
      potential_move = Piece.add_positions(@pos, delta)
      if @board.in_bounds?(potential_move)
        piece = @board.piece_here(potential_move)
        moves << potential_move if valid_step_move?(piece)
      end
    end
    moves
  end

end
