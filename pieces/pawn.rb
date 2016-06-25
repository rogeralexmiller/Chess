require_relative 'stepping_piece'

class Pawn < SteppingPiece

  def valid_pawn_move?(position)
    @board.in_bounds?(position) && !@board.piece_here(position)
  end

  def pawn_delta
    color == :white ? DELTAS[:up] : DELTAS[:down]
  end

  def double_pawn_move_if_valid(front_pos, delta)
    unless @moved
      two_moves_pos = Piece.add_positions(front_pos, delta)
      unless @board.piece_here(two_moves_pos)
        two_moves_pos
      end
    end
  end

  def take_positions(front_pos)
    left_take = Piece.add_positions(front_pos,DELTAS[:left])
    right_take = Piece.add_positions(front_pos,DELTAS[:right])
    [left_take, right_take]
  end

  def valid_take?(piece)
    piece && piece.color != self.color
  end

  def add_valid_take_moves(moves, front_pos)
    takes = take_positions(front_pos)

    takes.each do |take|
      if @board.in_bounds?(take)
        piece = @board.piece_here(take)
        moves << take if valid_take?(piece)
      end
    end
    moves
  end

  def add_normal_moves(front_pos, delta)
    moves = []

    if valid_pawn_move?(front_pos)
      moves << front_pos
      double_move = double_pawn_move_if_valid(front_pos, delta)
      moves << double_move if double_move
    end
    moves
  end

  def moves
    delta = pawn_delta

    front_pos = Piece.add_positions(@pos, delta)

    moves = add_normal_moves(front_pos, delta)

    moves = add_valid_take_moves(moves, front_pos)
  end

  def to_s
    @color == :white ? "♙" : "♟"
  end

  def dup
    Pawn.new(@board, @color, @pos)
  end

end
