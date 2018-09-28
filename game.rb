require_relative "board.rb"

class Game

  def initialize(size = [9, 9], bombs = 9)
    @board = Board.new(size, bombs)
  end

  def play

    board.display

    # until over?
    #   board.display
    #   take_turn
    # end
    #
    # board.won? ? "Congratulations!" : "Whoops!"

  end

  def take_turn
    input = get_input
    pos = input[:position]
    action = input[:action]

    action == 'r' ? board[pos].reveal : board[pos].flag
  end

  def get_input

    response = nil

    until response && valid_input?(response)
      puts "Choose a location to reveal or flag ('x,y' or 'x,y f' to flag)"
      print " > "

      begin
        response = parse_input(gets.chomp)
      rescue
        puts "Invalid input, please follow the format."
        puts ""
        response = nil
      end

    end

    response

  end

  def parse_input(response)
    # response should look like this:
    ## 1,1 f
    ## 2,4

    # input should return this:
    ## {position: [0,1], action: 'f'} to flag the position
    ## {position: [2,4], action: 'r'} to reveal the position

    input = {
      position: [],
      action: 'r',
    }

    action_separated = response.split(" ")

    # ok this is being annoying right now

    input

  end

  def valid_input?(input)
    pos = input[:position]
    action = input[:action]

    # if we're flagging, check ensure it's hidden
    # if we're revealing, make sure it's not flagged
    # make sure position is within bounds of the board

    # for now return true

    true

  end

  def over?
    board.won? || board.lost?
  end

  # private
  attr_reader :board

end

# game = Game.new([9, 9], 10) # easy
game = Game.new([10, 10], 13) # medium-ish
# game = Game.new([16, 16], 24) # medium
# game = Game.new([25, 25], 99) # hard

game.play
