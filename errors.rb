class FormatError < StandardError
  def message
    "Invalid input, please follow the format of 'x,y' or 'x,y f'"
  end
end

class FlaggedError < StandardError
  def message
    "That position is flagged! Unflag to reveal."
  end
end
