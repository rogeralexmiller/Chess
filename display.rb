require 'colorize'
require 'io/console'
require_relative 'board'


class Display

  KEYMAP = {
    " " => :space,
    "h" => :left,
    "j" => :down,
    "k" => :up,
    "l" => :right,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "\t" => :tab,
    "\r" => :select,
    "\n" => :newline,
    "\e" => :escape,
    "q" => :quit
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }

  attr_accessor :selected, :highlighted_positions

  def initialize(board,game, pos = [0,0])
    @cursor_pos = pos
    @selected = nil
    @board = board
    @background_color = :faux_white
    @game = game
    @highlighted_positions = []
  end

  def get_input
    key = KEYMAP[STDIN.getch]
    handle_key(key)
  end

  def handle_key(key)
    case key
    when :up, :down, :right, :left
      update_pos(MOVES[key])
    when :newline, :select
      if @selected
        # move_to_space (selected piece --> cursor_position)
        @game.move_to_space(@cursor_pos)
      else
        # select_piece (at the cursor position)
        @game.select_piece(@cursor_pos)
      end
    when :quit
      exit(0)
    end
  end

  def update_pos(diff)
    new_pos = Piece.add_positions(@cursor_pos, diff)
    @cursor_pos = new_pos
  end

  def highlight_valid_moves
    piece = @board.piece_here(@selected)
    @highlighted_positions = piece.valid_moves
  end

  def render
    (0...8).each do |row_idx|
      switch_background_color
      (0...8).each do |col_idx|
        bc = background_color
        pos = [row_idx, col_idx]

        # Set Background color / highlight any valid moves
        if pos == cursor_pos
          bc = :yellow
        elsif @highlighted_positions.include?(pos)
          bc = :blue
        end

        # Set color of piece (if there is one)
        if @board.piece_here(pos)
          space_val = @board.piece_here(pos)
          colorize_color = Piece::RENDER_COLOR[space_val.color]
        else
          space_val = " "
          colorize_color = :black
        end

        print " #{space_val} ".colorize(color: colorize_color, background: bc).bold
        switch_background_color
      end
      puts
    end
  end

  private
  attr_reader :cursor_pos, :board, :background_color

  def switch_background_color
    @background_color = (background_color == :faux_white) ? :white : :faux_white
  end

end

# b = Board.new
# b.move_into_checkmate
# display = Display.new b
# until b.checkmate?(:white) || b.checkmate?(:black)
#   system('clear')
#   display.render
#   cursor_move = display.get_input
# end
#
# display.render
# puts b.checkmate?(:white)
