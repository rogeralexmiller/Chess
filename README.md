# Chess Commander

Chess commander is a command-line chess game written in Ruby.

## Want to play now?

### Make sure you have Ruby installed
There are many resources that can help you get up and running with Ruby
but this one stands out: <a href="http://installrails.com/steps/choose_os"> Ruby
Tutorial </a>

Once Ruby is happily installed, download this repo, navigate to its root with
your command line
and enter the following command:
'''shell
ruby game.rb
'''

## How did I build it?

The underlying code for Chess Commander is composed of a game class that sets
everything in motion and handles general game play, a board class that keeps
track of which pieces are where, a display class that handles receiving user
input and rendering, and a number of piece classes that contain the logic for
how each piece moves.

### Piece By Piece

Getting the pieces to behave according to the rules of chess was definitely the
most challenging aspect of building this game.

To keep things simple, all the individual piece classes inherit a number of attributes and methods from a
parent class `Piece`. Each piece is initialized with variables representing
the board, its color, starting position, and a boolean for whether or not it has been moved.

### Movement

In chess, pieces can be categorized according to how they move. Queens, bishops and rooks
all slide along a given vector, while knights, kings, and pawns can step to a limited number of squares
depending on the layout of the board.

To replicate these two different behaviors, I created two classes, `SlidingPiece` and `SteppingPiece`
that each contain different logic for how a piece of that class moves. In order for sliding pieces to know
which squares they can move to, they need to check along a directional line to see how far they can move before hitting
either another piece or the edge of the board.
