class Strategy
  attr_accessor :hand

  DEFAULT_CONFIGURATION = {
    pre_flop: {
      suited: { king: 2, queen: 6, jack: 8 },
      unsuited: {
        ace:   2,
        king:  5,
        queen: 8,
        jack:  10
      },
      pair: 3
    },
    flop: {
      hand_type:            :two_pair,
      hidden_pair:          2,
      pocket_pair:          3,
      four_to_flush_hidden: 10
    },
    river: {
      hidden_pair: 2,
      hand_type:   :two_pair,
      outs:        21
    }
  }

  def initialize(config = nil)
    @config = config || DEFAULT_CONFIGURATION
    @hand = nil
  end

  def bet?
    if hand.pre_flop?
      passing_pre_flop?
    elsif hand.flop?
      passing_flop?
    elsif hand.river?
      passing_river?
    end
  end

  private

  attr_reader :config

  def passing_pre_flop?
    passing_suited? || passing_unsuited? || passing_pair?
  end

  def passing_flop?
    passing_flop_hand? || passing_pocket_pair? || passing_hidden_pair? || passing_four_to_flush?
  end

  def passing_river?
    passing_river_hand? || passing_river_hidden_pair? || passing_river_outs?
  end

  def passing_suited?
    return false unless suited?

    !!pre_flop_match(:suited)
  end

  def passing_unsuited?
    !!pre_flop_match(:unsuited)
  end

  def passing_pair?
    return false unless hand.type == :pair

    cards.first.rank >= config.dig(:pre_flop, :pair)
  end

  def passing_flop_hand?
    hand.better_or_equal_to?(config.dig(:flop, :hand_type))
  end

  def passing_pocket_pair?
    return false unless pair = hand.pocket_pair

    pair.first.rank >= config.dig(:flop, :pocket_pair)
  end

  def passing_hidden_pair?
    return false unless pair = hand.hidden_pair_only

    pair.first.rank >= config.dig(:flop, :hidden_pair)
  end

  def passing_four_to_flush?
    return false unless suit = hand.flush_suit(n: 4)

    hand.pocket.any? do |card|
      card.rank >= config.dig(:flop, :four_to_flush_hidden) &&
        card.suit.downcase == suit
    end
  end

  def passing_river_hand?
    hand.better_or_equal_to?(config.dig(:river, :hand_type))
  end

  def passing_river_hidden_pair?
    return false unless pair = hand.hidden_pair_only

    pair.first.rank >= config.dig(:river, :hidden_pair)
  end

  def pre_flop_match(type)
    config.dig(:pre_flop, type).detect do |suit, kicker|
      if high_card = cards.detect(&suit)
        (cards - [high_card]).first.rank >= kicker
      end
    end
  end

  def passing_river_outs?
    hand.outs < config.dig(:river, :outs)
  end

  def suited?
    cards.map(&:suit).uniq.one?
  end

  def cards
    hand.cards
  end
end
