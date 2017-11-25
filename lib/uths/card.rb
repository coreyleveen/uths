class Card
  include Comparable

  attr_reader :suit, :rank

  def initialize(suit:, rank:)
    @suit = suit.downcase
    @rank = rank
  end

  def to_s
    "#{Uths::RANK_MAP[rank].capitalize} of #{suit.capitalize}"
  end

  def <=>(other_card)
    rank <=> other_card.rank
  end

  Uths::RANK_MAP.each do |k, v|
    define_method("#{v}?") { rank == k }
    define_method(v) { rank == k }
  end

  Uths::RANK_WORDS.product(Uths::SUITS).each do |combination|
    rank, suit = combination.first, combination.last

    define_method("#{rank}_of_#{suit}?") do
      suit == self.suit && rank == Uths::RANK_MAP[self.rank]
    end

    define_method("#{rank}_of_#{suit}") do
      suit == self.suit && rank == Uths::RANK_MAP[self.rank]
    end
  end
end
