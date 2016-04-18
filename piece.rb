require 'byebug'

class Piece

  attr_reader :color

  def initialize(board, color, pos)
    @pos = pos
    @color = color
    @board = board
  end

  def to_s
    @color[0]
  end

  private
  attr_reader :pos, :board

end

class SteppingPiece < Piece

end

class SlidingPiece < Piece

  DELTAS = {
    :horizontal => [ [0,1], [0,-1] ],
    :vertical => [ [1,0], [-1,0] ],
    :down_diag => [ [1,1], [-1,-1] ],
    :up_diag => [ [1,-1], [-1,1] ]
  }

  def moves
    moves = []
    directions = move_dirs
    direction_deltas = []
    if directions.include?(:diagonal)
      up_diag_deltas = DELTAS[:up_diag]
      down_diag_deltas = DELTAS[:down_diag]
      direction_deltas += [up_diag_deltas, down_diag_deltas]
    end

    if directions.include?(:lateral)
      row_deltas = DELTAS[:horizontal]
      col_deltas = DELTAS[:vertical]
      direction_deltas += [row_deltas, col_deltas]
    end

    direction_deltas.each do |deltas|
      # iterate over first set of deltas
      ## up_diag --> down and to the left
      ## down_diag --> down and to the right
      ## horizontal --> to the right
      ## vertical --> down
      delta1, delta2 = deltas
      self.check_along_direction(moves, delta1)

      # iterate over the second set of deltas
      ## up_diag --> up and to the right
      ## down_diag --> up and to the left
      ## horizontal --> to the left
      ## vertical --> up
      self.check_along_direction(moves, delta2)
    end

    moves
  end

  def move_dirs
    []
  end

  protected
  def check_along_direction(moves, delta)
    starting_pos = SlidingPiece.next_pos(@pos, delta)
    while @board.in_bounds?(starting_pos) #&& not @board[current_pos]
      if board[starting_pos]
        piece_here = @board[starting_pos]
        moves << starting_pos unless piece_here.color == self.color
        break
      end
      moves << starting_pos

      starting_pos = SlidingPiece.next_pos(starting_pos, delta)
    end
  end

  def self.next_pos(pos, delta)
    # debugger
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:lateral]
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :lateral]
  end
end
