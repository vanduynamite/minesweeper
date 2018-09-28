class Position

  SPACER = "  "
  HIDDEN = "."
  EMPTY = " "
  FLAGGED = "F"
  BOMB = "*"

  def initialize
    @hidden = true
    @value = 0 # -1 for bombs, otherwise 0-8 for num_surrounding_bombs
    @flagged = false
  end

  def set_value(value)
    self.value = value
  end

  def display
    # this order matters a great deal!
    symbol = value
    symbol = EMPTY if value == 0
    symbol = BOMB if value == -1
    # symbol = HIDDEN if hidden
    # symbol = FLAGGED if flagged

    "#{SPACER}#{symbol}#{SPACER}"
  end

  def reveal
    self.hidden = false
    # again...WHY???
    # ************************************
    # ************************************
    # also have to reveal adjacent empties
    # ************************************
    # ************************************
  end

  def flag
    flagged = true
  end

  def bomb?
    value == -1
  end

  def revealed?
    !hidden
  end

  def self.spacer
    SPACER
  end

  # private
  attr_accessor :flagged, :hidden, :value

end
