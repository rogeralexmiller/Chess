require_relative 'sliding_piece'

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :lateral]
  end

  def to_s
    "♕"
  end

end
