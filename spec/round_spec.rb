require "spec_helper"

RSpec.describe Round do
  let(:round) { Round.new(player: player, dealer: dealer) }
  let(:player) { Player.new(chips: 5_000, strategy: Strategy.new) }
  let(:dealer) { Dealer.new }


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

  describe "#play" do
    subject { -> { round.play } }

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

  describe "player winnings" do
    context "when the dealer qualifies" do
      let(:dealer_pocket) { [nine_of_spades, king_of_spades] }

      context "and the player wins" do
        let(:player_pocket) { [king_of_spades, king_of_diamonds] }
        # blind, ante, play bets win
        it { expect { round.play }.to change { player.chips }.by(+600) }
      end

      context "and the player loses" do
        # blind, ante, play bets lose
        it { expect { round.play }.to change { player.chips }.by(-700) }
      end
    end

    context "when the dealer does not qualify" do
      context "and the player wins" do
        # blind, play bets win, ante push
        it { expect { round.play }.to change { player.chips }.by(+500) }
      end

      context "and the player loses" do
        let(:player_pocket) { [four_of_hearts, jack_of_clubs] }

        # blind, play bets lose, ante push
        it { expect { round.play }.to change { player.chips }.by(-200) }
      end
    end

    context "when the player has trips" do
      let(:player_pocket) { [three_of_spades, three_of_clubs] }

      it { expect { round.play }.to change { player.chips }.by(+800) }

      context "and the player loses the hand" do
        let(:dealer_pocket) { [queen_of_spades, queen_of_clubs] }

        it { expect { round.play }.to change { player.chips }.by(-400) }
      end
    end

    context "when the player has a straight" do
      let(:flop) { [two_of_hearts, four_of_clubs, five_of_diamonds] }

      it { expect { round.play }.to change { player.chips }.by(+1100) }
    end

    context "when the player has a flush" do
      let(:player_pocket) { [ace_of_clubs, two_of_clubs] }
      let(:flop) { [four_of_clubs, nine_of_clubs, ten_of_clubs] }

      it { expect { round.play }.to change { player.chips }.by(+1350) }
    end

    context "when the player has a full house" do
      let(:flop) { [ace_of_spades, ace_of_diamonds, three_of_hearts] }

      it { expect { round.play }.to change { player.chips }.by(+1700) }
    end

    context "when the player has quads" do
      let(:flop) { [ace_of_spades, ace_of_diamonds, ace_of_hearts] }

      it { expect { round.play }.to change { player.chips }.by(+4600) }
    end

    context "when the player has a straight flush" do
      let(:player_pocket) { [ace_of_spades, two_of_spades] }
      let(:flop) { [three_of_spades, four_of_spades, five_of_spades] }

      it { expect { round.play }.to change { player.chips }.by(+9600) }
    end

    context "when the player has a royal flush" do
      let(:player_pocket) { [ace_of_spades, king_of_spades] }
      let(:flop) { [queen_of_spades, jack_of_spades, ten_of_spades] }

      it { expect { round.play }.to change { player.chips }.by(55_600) }
    end
  end
end
