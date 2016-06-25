require_relative 'sliding_piece'

class Queen < SlidingPiece
  def move_directions
    [:diagonal, :lat_vert]
  end

  def to_s
    @color == :white ? "♕" : "♛"
  end

end
