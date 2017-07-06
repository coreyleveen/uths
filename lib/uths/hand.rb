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
    elsif best = straight_flush
      {
        straight_flush: best,
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

  def straight_flush
    if flush?
      if cards.count == 5
        straight_flush = [
          send("five_of_#{flush_suit}"),
          send("four_of_#{flush_suit}"),
          send("three_of_#{flush_suit}"),
          send("two_of_#{flush_suit}"),
          send("ace_of_#{flush_suit}")
        ]

        return straight_flush if straight_flush.all?
      end
    end
  end

  def royal_flush
    if flush?
      royal_flush = [
        send("ace_of_#{flush_suit}"),
        send("king_of_#{flush_suit}"),
        send("queen_of_#{flush_suit}"),
        send("jack_of_#{flush_suit}"),
        send("ten_of_#{flush_suit}")
      ]

      royal_flush.all? && royal_flush
    end
  end

  def flush?
    !!flush_suit
  end

  def flush_suit
    # Occurs with with any flush hand

    return nil unless cards.count >= 5

    suits = cards.map(&:suit)

    @flush_suit ||= Uths::SUITS.detect do |suit|
                      suits.count(suit) >= 5
                    end&.downcase&.to_sym
  end
end
