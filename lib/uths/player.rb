class Player
  attr_accessor :hand, :chips

  def initialize(chips:, strategy:)
    @chips    = chips
    @strategy = strategy
    @hand     = nil
  end

  def bet?
    strategy.hand = hand
    strategy.bet?
  end

  private

  attr_reader :strategy
end
