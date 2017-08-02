require "spec_helper"

RSpec.describe Player do
  let(:player) { Player.new(chips: 5_000) }

  describe "#chips" do
    subject { player.chips }

    it { is_expected.to eq(5_000) }
  end

  describe "#bet?" do
    subject { player.bet? }

    let(:hand) { Hand.call(cards) }

    before { player.hand = hand }

    context "pre-flop" do
      context "and the betting conditions are satisfied" do
        let(:cards) { [king_of_hearts, five_of_clubs] }

        it { is_expected.to eq(true) }
      end

      context "and the betting conditions are not satisfied" do
        let(:cards) { [king_of_hearts, two_of_clubs] }

        it { is_expected.to be(false) }
      end
    end

    context "flop" do
      context "and the betting conditions are satisfied" do
        let(:cards) { [king_of_hearts, two_of_clubs] + table_cards }
        let(:table_cards) { [king_of_spades, eight_of_diamonds, queen_of_hearts] }

        it { is_expected.to eq(true) }
      end

      context "and the betting conditions are not satisfied" do
        let(:cards) { [king_of_hearts, two_of_clubs] + table_cards }
        let(:table_cards) { [three_of_spades, five_of_hearts, eight_of_diamonds] }

        it { is_expected.to eq(false) }
      end
    end

    context "river" do
      context "and the betting conditions are satisfied" do
        let(:cards) { [king_of_hearts, two_of_clubs, five_of_hearts, eight_of_diamonds, king_of_spades] }

        it { is_expected.to eq(true) }
      end

      context "and the betting conditions are not satisfied" do
        let(:cards) { [two_of_spades, three_of_hearts, five_of_diamonds, six_of_clubs, eight_of_spades] }

        it { is_expected.to eq(false) }
      end
    end
  end
end
