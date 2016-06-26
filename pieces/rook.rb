require_relative 'sliding_piece'

class Rook < SlidingPiece

  def move_directions
    [:lat_vert]
  end

  def to_s
    @color == :white ? "♖" : "♜"
  end
end
