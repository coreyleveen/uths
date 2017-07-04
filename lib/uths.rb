require "uths/version"

module Uths
  SUITS = %w(Spades Clubs Diamonds Hearts)
  RANKS = Array(2..14)

  RANK_MAP = {
    2  => "two",
    3  => "three",
    4  => "four",
    5  => "five",
    6  => "six",
    7  => "seven",
    8  => "eight",
    9  => "nine",
    10 => "ten",
    11 => "jack",
    12 => "queen",
    13 => "king",
    14 => "ace"
  }
end
