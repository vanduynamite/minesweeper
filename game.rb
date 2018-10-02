require_relative "board.rb"
require_relative "errors.rb"
require "byebug"

class Game

  def initialize(size = [9, 9], bombs = 9)
    @board = Board.new(size, bombs)
  end

  def play

    # board.display

    until over?
      system("clear")
      board.display
      take_turn
    end


    system("clear")
    board.display

    puts board.lost? ? "Whoops! Kaboom!!!" : "Congratulations!"

  end

  def take_turn
    input = get_input
    pos = input[:position]
    action = input[:action]

    action == 'r' ? board[pos].reveal : board[pos].flag

    # ***********************************************************
    # ***********************************************************
    # also have to reveal adjacent empties, if empty was revealed
    # ***********************************************************
    # ***********************************************************
  end

  def get_input
    puts "Choose a location to reveal or flag ('x,y' or 'x,y f' to flag)"
    print " > "

    begin
      response = parse_input(gets.chomp)
    rescue FormatError, FlaggedError => e
      puts e.message
      print " > "
      retry
    end

    response
  end

  def parse_input(response)
    input = {
      position: [],
      action: '',
    }

    response_separated = response.split(" ")
    response_separated << "r" if response_separated.length == 1
    raise FormatError unless response_separated.length == 2

    input[:action] = response_separated[1]
    input[:position] = response_separated[0].split(",").map { |el| el.to_i }

    raise FormatError unless valid_input?(input)
    raise FlaggedError unless not_flagged?(input)

    input

  end

  def valid_input?(input)
    pos = input[:position]

    return false unless action = "r" || action = "f"
    return false unless pos.length == 2
    return false unless pos[0].between?(0, board.height - 1)
    return false unless pos[1].between?(0, board.width - 1)

    true
  end

  def not_flagged?(input)
    pos = input[:position]
    action = input[:action]

    return false if action == 'r' && board[pos].flagged?

    true
  end

  def over?
    board.won? || board.lost?
  end

  # private
  attr_reader :board

end



# game = Game.new([3,3], 1) # simple, for testing
game = Game.new([9, 9], 10) # easy
# game = Game.new([10, 10], 13) # medium-ish
# game = Game.new([16, 16], 24) # medium
# game = Game.new([25, 25], 99) # hard


game.play
