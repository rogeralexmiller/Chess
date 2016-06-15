# Chess Commander

Chess commander is a command-line chess game written in Ruby.

## Want to play now?

### Make sure you have Ruby installed
There are many resources that can help you get up and running with Ruby
but this one stands out: <a href="http://installrails.com/steps/choose_os"> Ruby
Tutorial </a>

Once Ruby is happily installed, download this repo, navigate to its root with
your command line
and enter the following command: `$ ruby game.rb`

## How did I build it?

The underlying code for Chess Commander is composed of a game class that sets
everything in motion and handles general game play, a board class that keeps
track of which pieces are where, a display class that handles receiving user
input and rendering, and a number of piece classes that contain the logic for
how each piece moves.

### Piece By Piece

Getting the pieces to behave according to the rules of chess was definitely the
most challenging aspect of building this game.

To keep things dry, all the individual piece classes inherit a number of attributes and methods from a
parent class `Piece`. Each piece is initialized with variables representing
the board, its color, starting position, and a boolean for whether or not it has been moved.

### Movement

In chess, pieces can be categorized according to how they move. Queens, bishops and rooks
all slide along a given directional line, while knights, kings, and pawns can step to a limited number of squares
depending on the layout of the board.

To replicate these two different behaviors, I created two classes, `SlidingPiece` and `SteppingPiece`
that each contain different logic for how a piece of that class moves.

#### Sliding Pieces
In order for sliding pieces to know which squares they can move to, they need to
check along a directional line to see how far they can move before hitting either
another piece or the edge of the board.

```
#sliding_piece.rb
#...
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
```

The `delta` in the above method is simply a single unit of change to a given position
on a grid represented by a two-dimensional array. For instance, `[0, 1]` is the
delta for a move one cell to the right, and `[1, 0]` is the delta for moving a
piece one cell downward.

#### Stepping Pieces

Unlike sliding pieces, stepping pieces have a fixed number of potential squares
they can move to, so to determine the possible moves you just have to loop through
them and filter out ones that are either off the board or are occupied by a piece
of the same color:

```
#stepping_piece.rb
#...
def valid_step_move?(piece)
  piece.nil? || piece.color != self.color
end

def moves_helper(deltas)
  moves = []
  deltas.each do |delta|
    potential_move = Piece.add_positions(@pos, delta)
    if @board.in_bounds?(potential_move)
      piece = @board.piece_here(potential_move)
      moves << potential_move if valid_step_move?(piece)
    end
  end
  moves
end
```


## Future Improvements

Going forward, I plan on adding castling and en passant moves to this chess game.
