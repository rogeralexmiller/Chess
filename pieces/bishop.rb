require_relative 'sliding_piece'

class Bishop < SlidingPiece
  def move_directions
    [:diagonal]
  end

  def to_s
    "♗"
  end
end
