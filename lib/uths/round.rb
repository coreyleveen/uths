class Round
  def initialize(player:, dealer:, ante: 100)
    @player = player
    @dealer = dealer
    @ante   = ante
  end

  def run!

  end

  def cards
    @cards ||= Deck.new.shuffle
  end

  private

  attr_reader :player, :dealer

end 
