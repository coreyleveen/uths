class Round
  TRIPS_BET_MULTIPLIERS = {
    trips:          3,
    straight:       4,
    flush:          7,
    full_house:     8,
    quads:          30,
    straight_flush: 40,
    royal_flush:    50
  }

  BLIND_BET_MULTIPLIERS = {
    straight:       1,
    flush:          1.5,
    full_house:     3,
    quads:          10,
    straight_flush: 50,
    royal_flush:    500
  }

  attr_reader :player, :dealer, :ante, :blind_bet, :trips_bet, :play_bet

  def initialize(player:, dealer:, ante: 100, trips_bet: nil)
    @player    = player
    @dealer    = dealer
    @ante      = ante
    @blind_bet = ante
    @trips_bet = trips_bet || ante
    @play_bet  = 0
  end

  def play
    dealer.player = player
    dealer.deal_pocket

    if player.bet?
      @play_bet = 4 * ante

      dealer.deal_flop
      dealer.deal_river
    else
      dealer.deal_flop

      if player.bet?
        @play_bet = 2 * ante

        dealer.deal_river
      else
        dealer.deal_river

        if player.bet?
          @play_bet = ante
        end
      end
    end

    if player_wins?
      award_chips
    elsif player_loses?
      deduct_chips
    end

    award_trips_bet
  end

  def cards
    @cards ||= Deck.new.shuffle
  end

  private

  def player_wins?
    player.hand > dealer.hand
  end

  def player_loses?
    player.hand < dealer.hand
  end

  def award_chips
    player.chips += blind_bet_award + play_bet + ante_bet_award
  end

  def deduct_chips
    if dealer.qualifies?
      player.chips -= ante + play_bet + trips_bet + blind_bet
    else
      player.chips -= play_bet + trips_bet + blind_bet
    end
  end

  def award_trips_bet
    player.chips += trips_bet_award
  end

  def ante_bet_award
    dealer.qualifies? ? ante : 0
  end

  def trips_bet_award
    TRIPS_BET_MULTIPLIERS.fetch(player.hand.type, 0) * trips_bet
  end

  def blind_bet_award
    (BLIND_BET_MULTIPLIERS.fetch(player.hand.type, 0) * blind_bet)
  end
end
