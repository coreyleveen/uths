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

  Uths::RANK_MAP.each do |k, v|
    define_method("#{v}?") { rank == k }
    define_method(v) { rank == k }
  end
end
