require_relative 'board'
require_relative 'display'
require_relative 'piece'

class Game

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @player_turn = :white
  end

  def switch_player_turn
    @player_turn = @player_turn == :white ? :black : :white
  end

  def select_piece(cursor_position)
    piece = @board.piece_here(cursor_position)

    if piece && piece.color == @player_turn
      if piece.valid_moves.empty?
        puts "No valid moves for that piece"
        return false
      end
      @display.selected = cursor_position
      @display.highlight_valid_moves
    end

    true
  end

  def move_to_space(cursor_position)
    piece = @board.piece_here(@display.selected)
    moves = @display.highlighted_positions
    if moves.include?(cursor_position)
      @board.move(@display.selected, cursor_position)
      @display.selected = nil
      @display.highlighted_positions = []
      switch_player_turn
    end
  end

  def run
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      system('clear')
      @display.render
      puts "#{@player_turn} is in check" if @board.in_check?(@player_turn)
      @display.get_input
    end

    system('clear')
    @display.render
    puts "Game over!"
    # puts @board.checkmate?(:white)
  end

end

game = Game.new

game.run
