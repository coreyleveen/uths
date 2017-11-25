require "uths/version"

module Uths
  SUITS = %w(spades clubs diamonds hearts)
  RANKS = Array(2..14)

  RANK_WORDS = %w(
    two
    three
    four
    five
    six
    seven
    eight
    nine
    ten
    jack
    queen
    king
    ace
  )

  RANK_MAP = RANKS.zip(RANK_WORDS).to_h

  STRATEGY = File.read("config/strategy.yaml")
end

def log(text)
  Logger.log(text)
end

require "uths/card"
require "uths/deck"
require "uths/hand"
require "uths/dealer"
require "uths/player"
require "uths/strategy"
require "uths/round"
require "uths/logger"
