require "spec_helper"

RSpec.describe Round do
  let(:round) { Round.new(player: player, dealer: dealer) }
  let(:player) { Player.new(chips: 5_000, strategy: Strategy.new) }
  let(:dealer) { Dealer.new }

  describe "#play" do
    subject { -> { round.play } }

    let(:player_pocket) { [ace_of_clubs, three_of_diamonds] }
    let(:dealer_pocket) { [king_of_spades, six_of_clubs] }

    let(:flop) { [three_of_hearts, queen_of_diamonds, nine_of_diamonds] }
    let(:player_flop) { player_pocket + flop }
    let(:dealer_flop) { dealer_pocket + flop }

    let(:river) { flop + [two_of_spades, five_of_hearts] }
    let(:player_river) { player_pocket + river }
    let(:dealer_river) { dealer_pocket + river }

    before do
      allow(dealer).to receive(:deal_pocket) do
        player.hand = Hand.call(player_pocket)
        dealer.hand = Hand.call(dealer_pocket)
      end

      allow(dealer).to receive(:deal_flop) do
        player.hand = Hand.call(player_flop)
        dealer.hand = Hand.call(dealer_flop)
      end

      allow(dealer).to receive(:deal_river) do
        player.hand = Hand.call(player_river)
        dealer.hand = Hand.call(dealer_river)
      end
    end

    it { is_expected.to change { dealer.player }.from(nil).to(player) }

    it do
      expect(dealer).to receive(:deal_pocket).and_call_original
      subject.call
    end

    context "pocket" do
      context "when the player bets" do
        it { is_expected.to change { round.play_bet }.to(400) }
      end
    end

    context "flop" do
      context "when the player bets" do
        let(:player_pocket) { [eight_of_hearts, three_of_diamonds] }

        it { is_expected.to change { round.play_bet }.to(200) }
      end
    end

    context "river" do
      context "when the player bets" do
        let(:player_pocket) { [two_of_clubs, five_of_spades] }

        it { is_expected.to change { round.play_bet }.to(100) }
      end

      context "when the player folds" do
        let(:player_pocket) { [four_of_clubs, seven_of_spades] }

        it do
          subject.call
          expect(round.play_bet).to be_zero
        end

        it { is_expected.to change { player.chips }.by(-200) }
      end
    end
  end

  describe "#blind_bet" do
    subject { round.blind_bet }

    it "is the same as the ante" do
      is_expected.to eq(100)
    end
  end

  describe "#trips_bet" do
    subject { round.trips_bet }

    context "when given a trips bet value" do
      let(:round) { Round.new(player: player, dealer: dealer, trips_bet: 200) }

      it { is_expected.to eq(200) }
    end

    context "when not given a trips bet value" do
      it "is the same as the ante" do
        is_expected.to eq(100)
      end
    end
  end
end
