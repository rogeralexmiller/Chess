require_relative 'sliding_piece'

class Rook < SlidingPiece
  def move_dirs
    [:lateral]
  end

  def to_s
    "♖"
  end
end
