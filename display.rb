require 'colorize'
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
    "\r" => :return,
    "\n" => :newline,
    "\e" => :escape
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }

  def initialize(board,pos = [0,0])
    @cursor_pos = pos
    @board = board
    @background_color = :black
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  def handle_key(key)

  end

  def render
    (0...8).each do |row_idx|
      switch_background_color
      (0...8).each do |col_idx|
        pos = [row_idx, col_idx]
        space_val = @board[pos] || " "
        print "#{space_val} ".colorize(color: :red,background: background_color)
        switch_background_color
      end
      puts
    end
  end

  private
  attr_reader :cursor_pos, :board, :background_color

  def switch_background_color
    @background_color = (background_color == :white) ? :black : :white
  end

end

b = Board.new
display = Display.new b
display.render


# puts "Hello world".colorize(color: :white, background: :black )
