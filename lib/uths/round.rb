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

  def initialize(player:, ante: 100, trips_bet: nil)
    @player    = player
    @dealer    = Dealer.new
    @ante      = ante
    @blind_bet = ante
    @trips_bet = trips_bet || ante
    @play_bet  = 0
    @folded    = false
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
        else
          fold
        end
      end
    end

    if player_folded?
      deduct_chips
    elsif player_wins?
      player.wins += 1

      award_chips
    elsif player_loses?
      deduct_chips
    end

    handle_trips_bet
  end

  def cards
    @cards ||= Deck.new.shuffle
  end

  private

  def fold
    @folded = true
  end

  def player_folded?
    @folded
  end

  def player_wins?
    player.hand > dealer.hand
  end

  def player_loses?
    player.hand < dealer.hand
  end

  def award_chips
    player.chips += play_bet + ante_bet_award + blind_bet_award
  end

  def deduct_chips
    player.chips -= play_bet + blind_bet

    if dealer.qualifies?
      player.chips -= ante
    end
  end

  def handle_trips_bet
    amount = TRIPS_BET_MULTIPLIERS.fetch(player.hand.type, 0) * trips_bet

    if amount.zero?
      player.chips -= trips_bet
    else
      player.chips += amount
    end
  end

  def ante_bet_award
    dealer.qualifies? ? ante : 0
  end

  def blind_bet_award
    BLIND_BET_MULTIPLIERS.fetch(player.hand.type, 0) * blind_bet
  end
end
