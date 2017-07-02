class Card
  include Comparable

  def initialize(suit:, rank:)
    @suit = suit
    @rank = rank
  end

  attr_reader :suit, :rank

  def to_s
    "#{humanized_rank} of #{suit}"
  end

  def <=>(other_card)
    rank <=> other_card.rank
  end

  private

  def humanized_rank
    case rank
    when 14 then "Ace"
    when 13 then "King"
    when 12 then "Queen"
    when 11 then "Jack"
    else rank
    end
  end
end
