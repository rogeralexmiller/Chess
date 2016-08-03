# Chess Command

Chess Command is a command-line chess game written in Ruby.

![Chess]

[Chess]: ./images/chess.png

## Want to play now?

### Make sure you have Ruby installed
There are many resources that can help you get up and running with Ruby
but this one stands out: <a href="http://installrails.com/steps/choose_os"> Ruby
Tutorial </a>

Once Ruby is happily installed, follow these steps:

1. Open terminal or whatever bash shell you're comfortable with.
2. Navigate to the folder you want the game to live in.
3. To clone the repository run this command:
`$ git clone https://github.com/rogeralexmiller/Chess_Command`
4. Navigate into the folder with this command:
`$ cd Chess_command`
5. Run this command to install the game's Ruby dependencies:
`$ bundle install`
6. Run this command to start the game!
 `$ ruby chess.rb`

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

#### Castling
Castling was a tricky feature to implement since it breaks the basic rules of how
both kings and rooks move. To implement castling, I augmented the King class
to get castling moves if any are available.

```
king.rb

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
```

To coordinate the movement of both the king and rooks I decided to delegate all
castling movement to the king, which moves its appropriate rook if a castling
move is taking place.
```
chess.rb

def move_to_space(cursor_position)
  piece = @board.piece_here(@display.selected)
  moves = @display.highlighted_positions
  if moves.include?(cursor_position)
    if piece.class == King && piece.can_castle?
      if piece.castling_left?(cursor_position)
        piece.move_castle(:left)
      end
      if piece.castling_right?(cursor_position)
        piece.move_castle(:right)
      end
    end
    ...
```

## Future Improvements

Going forward, I plan on adding en passant moves to this chess game.
