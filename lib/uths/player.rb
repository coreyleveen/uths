class Player
  attr_accessor :hand, :chips, :wins

  def initialize(chips:, strategy: Strategy.new)
    @chips    = chips
    @strategy = strategy
    @hand     = nil
    @wins     = 0
  end

  def bet?
    strategy.hand = hand
    strategy.bet?
  end

  private

  attr_reader :strategy
end
