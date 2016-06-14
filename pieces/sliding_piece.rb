require_relative 'piece'
require('byebug')

class SlidingPiece < Piece

  DELTAS = {
    :lat_vert => [ [0,1], [0,-1], [1,0], [-1,0] ],
    :diag => [ [1,1], [-1,-1], [1,-1], [-1,1] ]
  }

  def moves
    moves = []
    deltas = get_piece_deltas
    deltas.each{|delta| moves += get_moves_along_direction(delta)}
    moves
  end

  protected
  def get_piece_deltas
    deltas = []
    deltas += DELTAS[:diag] if move_directions.include?(:diagonal)
    deltas += DELTAS[:lat_vert] if move_directions.include?(:lat_vert)
    deltas
  end

  def get_moves_along_direction(delta)
    moves = []
    current_pos = Piece.add_positions(@pos, delta)
    while @board.in_bounds?(current_pos)
      unless board[current_pos].nil?
        piece_here = @board[current_pos]
        moves << current_pos unless piece_here.color == self.color
        break
      end
      moves << current_pos
      current_pos = Piece.add_positions(current_pos, delta)
    end
    moves
  end

end
