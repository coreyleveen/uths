class Deck
  SUITS = %w(Spades Clubs Diamonds Hearts)
  RANKS = Array(2..14)

  def initialize
    @cards = SUITS.product(RANKS)
  end

  def shuffle
    cards.shuffle
  end

  private

  attr_reader :cards
end
