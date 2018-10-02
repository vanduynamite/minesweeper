require "byebug"
require_relative "position.rb"

class Board

  SPACER = Position.spacer
  LINE_SPACE = SPACER.chars.reduce("") { |acc, _| acc + "\n" }

  def initialize(size, bombs)
    @bombs = bombs
    @grid = initialize_grid(size, bombs)
  end

  def [](pos)
    x = pos.first
    y = pos.last
    grid[x][y]
  end

  def display
    print " #{SPACER}"
    (0...width).each { |i| print "#{SPACER}#{i}#{SPACER}"}
    puts LINE_SPACE
    grid.each_with_index do |row, i|
      print "#{i}#{SPACER}"
      row.each { |pos| print pos.display }
      puts LINE_SPACE
    end
  end

  def won?
    # byebug
    hidden_tiles == bombs
  end

  def lost?
    # byebug
    grid.any? do |row|
      row.any? do |pos|
        pos.bomb? && pos.revealed?
      end
    end
  end

  def width
    grid.first.length
  end

  def height
    grid.length
  end

  private
  attr_accessor :grid, :size, :bombs


  def hidden_tiles
    grid.map do |row|
      row.count { |pos| !pos.revealed? }
    end.reduce(:+)
  end

  def initialize_grid(size, bombs)
    build_grid(size)
    populate_bombs(bombs)
    populate_numbers
  end

  def build_grid(size)
    result = Array.new(size.first) {[]}

    result.each do |row|
      size[1].times { row << Position.new }
    end

    self.grid = result
  end

  def populate_bombs(bombs)
    all_positions = get_all_positions

    bombs.times do |i|
      bomb_pos = all_positions.sample
      all_positions.delete(bomb_pos)
      row = bomb_pos.first
      col = bomb_pos.last
      grid[row][col].set_value(-1)
    end

  end

  def get_all_positions
    all_positions = []

    (0...height).each do |i|
      (0...width).each do |j|
        all_positions << [i, j]
      end
    end

    all_positions
  end

  def populate_numbers
    grid.each_with_index do |row, i|
      row.each_with_index do |pos, j|
        num_bombs = surrounding_pos([i, j]).count { |pos2| pos2.bomb? }
        pos.set_value(num_bombs) unless pos.bomb?
      end
    end
  end

  def surrounding_pos(pos)
    row = pos.first
    col = pos.last

    results = []

    results << grid[row - 1][col - 1] if row > 0 && col > 0           # NW
    results << grid[row - 1][col    ] if row > 0                      # N
    results << grid[row - 1][col + 1] if row > 0  && col < width - 1  # NE

    results << grid[row    ][col - 1] if col > 0                      # W
    results << grid[row    ][col + 1] if col < width - 1              # S

    results << grid[row + 1][col - 1] if row < height - 1 && col > 0  # SW
    results << grid[row + 1][col    ] if row < height - 1             # E
    results << grid[row + 1][col + 1] if row < height - 1 && col < width - 1  # SE

    results
  end

end
