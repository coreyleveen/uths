class Hand
  def initialize(pocket:)
    @pocket = pocket
  end

  def pair?
    pocket.first.rank == pocket.last.rank
  end

  def high_card
    pocket.max
  end

  private

  attr_reader :pocket
end
