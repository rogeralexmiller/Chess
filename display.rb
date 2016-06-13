require 'colorize'
require 'io/console'
require_relative 'board'


class Display

  KEYMAP = {
    " " => :space,
    "j" => :left,
    "k" => :down,
    "i" => :up,
    "l" => :right,
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

  def initialize(board, game, pos = [0,0])
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
        @game.move_to_space(@cursor_pos)
      else
        @game.select_piece(@cursor_pos)
      end
    when :quit
      exit(0)
    end
  end

  def update_pos(diff)
    new_pos = Piece.add_positions(@cursor_pos, diff)
    @cursor_pos = new_pos if @board.in_bounds?(new_pos)
  end

  def highlight_valid_moves
    piece = @board.piece_here(@selected)
    @highlighted_positions = piece.valid_moves
  end

  def render
    puts "\n"
    (0...8).each do |row_idx|
      switch_background_color
      print " #{8-row_idx} "
      (0...8).each do |col_idx|
        pos = [row_idx, col_idx]
        bc = get_background_color(pos)
        values = space_values(pos)

        print " #{values[:value]} ".colorize(color: values[:color], background: bc).bold
        switch_background_color
      end
      puts
    end
    puts '    ' + ("A".."H").to_a.join('  ')
  end

  private
  def space_values(pos)
    if @board.piece_here(pos)
      space_val = @board.piece_here(pos)
      colorize_color = Piece::RENDER_COLOR[space_val.color]
    else
      space_val = " "
      colorize_color = :black
    end
    {value: space_val, color: colorize_color}
  end

  def get_background_color(pos)
    if pos == cursor_pos
      :light_cyan
    elsif @highlighted_positions.include?(pos)
      :light_black
    else
      background_color
    end
  end
  attr_reader :cursor_pos, :board, :background_color

  def switch_background_color
    @background_color = (background_color == :faux_white) ? :white : :faux_white
  end
end
