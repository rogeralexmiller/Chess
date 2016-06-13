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
