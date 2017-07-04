class Card
  include Comparable

  def initialize(suit:, rank:)
    @suit = suit
    @rank = rank
  end

  attr_reader :suit, :rank

  def to_s
    "#{Uths::RANK_MAP[rank].capitalize} of #{suit}"
  end

  def <=>(other_card)
    rank <=> other_card.rank
  end
end
