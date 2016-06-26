require_relative 'board'
require_relative 'display'
require_relative 'pieces/piece'
require 'byebug'
class Game

  def initialize
    @board = Board.new
    @board.move_into_castle
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
      if piece.class == King && piece.can_castle?
        if piece.castling_left?(cursor_position)
          piece.move_castle(:left)
        end
        if piece.castling_right?(cursor_position)
          piece.move_castle(:right)
        end
      end
      @board.move(@display.selected, cursor_position)
      @display.selected = nil
      @display.highlighted_positions = []
      switch_player_turn
    elsif piece.color == @player_turn
      @display.selected = nil
      @display.highlighted_positions = []
      select_piece(cursor_position)
    end
  end

  def run
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      system('clear')
      puts "Controls:"
      puts "up:   i   down:  k"
      puts "left: j   right: l"
      @display.render
      puts "#{@player_turn} is in check" if @board.in_check?(@player_turn)
      @display.get_input
    end

    system('clear')
    @display.render
    switch_player_turn
    puts "#{@player_turn} wins!"
  end

end

game = Game.new
game.run
