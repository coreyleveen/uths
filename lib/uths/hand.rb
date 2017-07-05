class Hand
  def initialize(cards)
    @cards = cards
  end

  attr_accessor :cards


  def best_hand
    if best = royal_flush
      {
        royal_flush: best,
        rest: (cards - best).sort.reverse
      }
    end
  end

  private

  # Define some convenience methods, e.g. two_of_hearts,
  # and return nil if not found in hand
  Deck.new.shuffle.each do |card|
    meth = card.to_s.downcase.gsub(" ", "_")
    define_method(meth) do
      cards.detect do |hand_card|
        card.rank == hand_card.rank &&
          card.suit == hand_card.suit
      end
    end
  end

  def royal_flush
    if suit = suit_with_five_cards
      royal_flush = [
        send("ace_of_#{suit}"),
        send("king_of_#{suit}"),
        send("queen_of_#{suit}"),
        send("jack_of_#{suit}"),
        send("ten_of_#{suit}")
      ]

      royal_flush.all? && royal_flush
    end
  end

  def suit_with_five_cards
    # Occurs with with any flush hand

    suits = cards.map(&:suit)

    Uths::SUITS.detect do |suit|
      suits.count(suit) >= 5
    end&.downcase&.to_sym
  end
end
