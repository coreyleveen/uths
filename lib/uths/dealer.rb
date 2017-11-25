class Dealer
  attr_accessor :hand, :player

  def deal_pocket(player_cards = [])
    if player_cards.any?
      first, second = player_cards

      @player_pocket = cards.select do |card|
        card.public_send(first) || card.public_send(second)
      end

      @cards -= @player_pocket
    end

    self.hand   = Hand.call(dealer_pocket)
    player.hand = Hand.call(player_pocket)
  end

  def deal_flop
    self.hand   = Hand.call(dealer_pocket + flop)
    player.hand = Hand.call(player_pocket + flop)
  end

  def deal_river
    self.hand   = Hand.call(dealer_pocket + flop + river)
    player.hand = Hand.call(player_pocket + flop + river)
  end

  def qualifies?
    hand.better_or_equal_to?(:pair)
  end

  def cards
    @cards ||= Deck.new.shuffle
  end

  private

  def dealer_pocket
    @dealer_pocket ||= cards.pop(2)
  end

  def player_pocket
    @player_pocket ||= cards.pop(2)
  end

  def flop
    @flop ||= cards.pop(3)
  end

  def river
    @river ||= cards.pop(2)
  end
end
