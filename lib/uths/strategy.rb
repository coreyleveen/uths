class Strategy
  attr_accessor :hand

  def initialize(config)
    @config = config
    @hand = nil
  end

  def bet?
    if hand.pre_flop?
      passing_pre_flop?
    else
      false
    end
  end

  private

  attr_reader :config

  def passing_pre_flop?
    passing_suited? || passing_unsuited? || passing_pair?
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

  def pre_flop_match(type)
    config.dig(:pre_flop, type).detect do |suit, kicker|
      if high_card = cards.detect(&suit)
        (cards - [high_card]).first.rank >= kicker
      end
    end
  end

  def suited?
    cards.map(&:suit).uniq.one?
  end

  def cards
    hand.cards
  end
end
