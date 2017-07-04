require "uths/card"

class Deck
  def initialize
    @cards = Uths::SUITS.product(Uths::RANKS).map do |comb|
      Card.new(suit: comb.first, rank: comb.last)
    end
  end

  def shuffle
    cards.shuffle
  end

  private

  attr_reader :cards
end
