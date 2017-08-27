class Round
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
        else
          fold_player
        end
      end
    end
  end

  def cards
    @cards ||= Deck.new.shuffle
  end

  private

  def fold_player
    trigger_loss
  end

  def trigger_loss
    player.chips -= pot
  end

  def pot
    ante + play_bet + trips_bet
  end
end
