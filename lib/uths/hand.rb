class Hand
  include Comparable

  HANDS = %i(
    royal_flush
    straight_flush
    quads
    full_house
    flush
    straight
    trips
    two_pair
    pair
    high_card
  )

  class << self
    def call(cards)
      new(cards).call
    end
  end

  attr_reader :pocket, :cards, :best, :type, :determinant

  def initialize(cards)
    @pocket      = cards.first(2)
    @cards       = cards.sort
    @type        = nil
    @best        = nil
    @determinant = nil
  end

  def call
    @type = HANDS.detect { |h| @best = send(h) }

    self
  end

  def <=>(other_hand)
    if type != other_hand.type
      HANDS.reverse.index(type) <=> HANDS.reverse.index(other_hand.type)
    elsif determinant != other_hand.determinant
      determinant.max <=> other_hand.determinant.max
    else
      best.max <=> other_hand.best.max
    end
  end

  def rest
    @rest ||= (cards - best).reverse
  end

  def better_or_equal_to?(hand_type)
    HANDS.reverse.index(type) >= HANDS.reverse.index(hand_type)
  end

  def pre_flop?
    cards.count == 2
  end

  def flop?
    cards.count == 5
  end

  def river?
    cards.count == 7
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

  def high_card
    [cards.max]
  end

  def pair
    repeating_cards(n: 2)
  end

  def two_pair
    if higher_pair = repeating_cards(n: 2)
      if lower_pair = repeating_cards(set: cards - higher_pair, n: 2)
        @determinant = higher_pair + lower_pair
        [*@determinant, (cards - @determinant).max]
      end
    end
  end

  def trips
    if trips = repeating_cards(n: 3)
      @determinant = trips
      remaining = cards - trips
      [*trips, *remaining.last(2)].sort.reverse
    end
  end

  def straight
    return unless flop? || river?

    if river?
      last_five  = cards.last(5)
      middle     = cards[1...-1]
      first_five = cards.first(5)

      higher_straight = [last_five, middle, first_five].detect do |set|
        consecutive?(set)
      end

      return higher_straight if higher_straight

      if low_straight?
        [cards.last, *cards.first(4)]
      end
    elsif (consecutive?(cards) || low_straight?)
      cards
    end
  end

  def flush
    return unless flush?

    if flop?
      cards
    else
      suited = cards.select { |card| card.suit.downcase == flush_suit }
      suited.sort.last(5).reverse
    end
  end

  def full_house
    if trips = repeating_cards(n: 3)
      @determinant = trips

      if pair = repeating_cards(set: cards - trips, n: 2)
        trips + pair
      end
    end
  end

  def quads
    if quads = repeating_cards(n: 4)
      @determinant = quads
      kicker = (cards - quads).max
      [*quads, kicker]
    end
  end

  def straight_flush
    if flush?
      if flop?
        if low_straight? || consecutive?(cards)
          cards
        end
      else
        last_five  = cards.last(5)
        middle     = cards[1...-1]
        first_five = cards.first(5)

        [last_five, middle, first_five].detect do |set|
          consecutive?(set)
        end
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

  def repeating_cards(set: cards, n:)
    repeating = set.select do |card|
      ranks.count { |rank| rank == card.rank } >= n
    end

    if repeating.any?
      # Only return the highest set of repeating cards
      max_rank = repeating.max.rank
      repeating.select { |card| card.rank == max_rank }.take(n)
    end
  end

  def consecutive?(set)
    range = set.min.rank..set.max.rank
    Array(range) == set.map(&:rank)
  end

  def low_straight?
    [14, 2, 3, 4, 5].all? { |rank| ranks.include?(rank) }
  end

  def flush?
    !!flush_suit
  end

  def flush_suit
    return nil unless cards.count >= 5

    Uths::SUITS.detect do |suit|
      suits.count(suit) >= 5
    end&.downcase
  end

  def ranks
    cards.map(&:rank)
  end

  def suits
    cards.map(&:suit)
  end
end
