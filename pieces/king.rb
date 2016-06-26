require_relative 'stepping_piece'
require 'byebug'

class King < SteppingPiece

  ROOKS = {
    white: {
      left: [7,0],
      right: [7,7]
    },
    black: {
      left: [0,0],
      right: [0,7]
    }
  }

  CASTLING_SQUARES = {
    white: {
      left: [[7,1], [7,2], [7,3]],
      right: [[7,5], [7,6]]
    },
    black: {
      right: [[0,5], [0,6]],
      left: [[0,1], [0,2], [0,3]]
    }
  }

  KING_CASTLE_MOVES = {
    white: {
      right: [7,6],
      left: [7,2]
    },
    black: {
      right: [0,6],
      left: [0,2]
    }
  }

  ROOK_CASTLE_MOVES = {
    white: {
      right: [7,5],
      left: [7,3]
    },
    black: {
      right: [0,5],
      left: [0,3]
    }
  }


  # 5. If all of these conditions are met, show the castle as a potential_move.

  def can_castle?
    return false if moved
    return false if board.in_check?(color)
    if can_castle_left? || can_castle_right?
      return true
    else
      false
    end
  end

  def spaces_occupied_or_in_check?(dir)
    spaces = CASTLING_SQUARES[color][dir]
    spaces.any? do |space|
      board.piece_here(space) || board.under_threat?(space, color)
    end
  end

  def castle_moved?(dir)
    rookPos = ROOKS[color][dir]
    rook = board.piece_here(rookPos)
    rook ? rook.moved : false
  end

  def can_castle_left?
    return false if castle_moved?(:left)
    return false if spaces_occupied_or_in_check?(:left)
    true
  end

  def can_castle_right?
    return false if castle_moved?(:right)
    return false if spaces_occupied_or_in_check?(:right)
    true
  end

  def moves
    moves = moves_helper(SteppingPiece::DELTAS.values)
  end

  def castling_left?(pos)
    left_squares = KING_CASTLE_MOVES[color][:left]
    pos == left_squares
  end

  def castling_right?(pos)
    right_squares = KING_CASTLE_MOVES[color][:right]
    pos == right_squares
  end

  def move_castle(dir)
    rook_pos = ROOKS[color][dir]
    rook_move = ROOK_CASTLE_MOVES[color][dir]
    board.move(rook_pos, rook_move)
  end

  def castle_moves(dir)
    [KING_CASTLE_MOVES[color][dir]]
  end

  def get_castle_moves
    moves = []
    if can_castle?
      if can_castle_left?
        moves.concat(castle_moves(:left))
      end
      if can_castle_right?
        moves.concat(castle_moves(:right))
      end
    end
    moves
  end

  def to_s
    @color == :white ? "♔" : "♚"
  end
end
