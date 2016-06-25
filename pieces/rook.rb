require_relative 'sliding_piece'

class Rook < SlidingPiece

  attr_reader :moved

  def initialize
    @moved = false
  end

  def move_directions
    [:lat_vert]
  end

  def to_s
    @color == :white ? "♖" : "♜"
  end
end
