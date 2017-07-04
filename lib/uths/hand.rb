class Hand
  def initialize(pocket:)
    @pocket = pocket
    @table_cards = []
  end

  attr_accessor :table_cards

  def pocket_pair?
    pocket.first.rank == pocket.last.rank
  end

  def pocket_high_card
    pocket.max
  end

  def best_hand
    if pair?
      :pair
    else
      :high_card
    end
  end

  private

  attr_reader :pocket

  def pair?
    total_hand.map(&:rank).uniq.length < total_hand.length
  end

  def total_hand
    pocket + table_cards
  end
end
