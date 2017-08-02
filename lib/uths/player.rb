class Player

  attr_reader :chips
  attr_accessor :hand

  def initialize(chips:)
    @chips = chips
    @hand = nil
  end

  # def bet?
    # if hand.pre_flop?
      # pre_flop_bet?
    # end
  # end
end
