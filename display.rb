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

  def initialize(board,pos = [0,0])
    @cursor_pos = pos
    @selected = false
    @board = board
    @background_color = :black
  end

  def get_input
    key = KEYMAP[STDIN.getc.chr]
    handle_key(key)
  end

  def handle_key(key)
    case key
    when :up, :down, :right, :left
      update_pos(MOVES[key])
    when :quit
      exit(0)
    when :select
      # other stuff
      @selected = !selected
    end
  end

  def update_pos(diff)
    new_pos = [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
    @cursor_pos = new_pos #if @board.in_bounds?(new_pos)
  end

  def render
    (0...8).each do |row_idx|
      switch_background_color
      (0...8).each do |col_idx|
        bc = background_color
        pos = [row_idx, col_idx]
        bc = :yellow if pos == cursor_pos

        space_val = @board[pos] || " "
        print "#{space_val} ".colorize(color: :red,background: bc)
        switch_background_color
      end
      puts
    end
  end

  private
  attr_reader :cursor_pos, :board, :background_color, :selected

  def switch_background_color
    @background_color = (background_color == :white) ? :black : :white
  end

end

b = Board.new
display = Display.new b
while true
  system('clear')
  display.render
  cursor_move = display.get_input
end
