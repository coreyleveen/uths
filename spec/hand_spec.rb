require "spec_helper"

RSpec.describe Hand do
  let(:hand) { Hand.new(pocket: pocket_cards) }
  let(:pocket_cards) { [card_1, card_2] }
  let(:card_1) { ten_of_hearts }
  let(:card_2) { nine_of_hearts }


  describe "#pocket_pair?" do
    subject { hand.pocket_pair? }

    context "when both cards have the same rank" do
      let(:card_2) { ten_of_spades }

      it { is_expected.to be(true) }
    end

    context "when both cards have differing rank" do
      it { is_expected.to be(false) }
    end
  end

  describe "#high_card" do
    subject { hand.pocket_high_card }

    let(:card_2) { king_of_spades }

    it { is_expected.to eq(card_2) }
  end

  describe "#best_hand" do
    subject { hand.best_hand }

    before { hand.table_cards = table_cards }

    context "high card" do
      let(:table_cards) { [two_of_diamonds, four_of_clubs, six_of_spades] }

      it { is_expected.to eq(:high_card) }
    end

    context "pair" do
      let(:table_cards) { [ten_of_spades, two_of_diamonds, four_of_clubs] }

      it { is_expected.to eq(:pair) }
    end

    context "two pair" do

    end

    context "three of a kind" do

    end

    context "straight" do

    end

    context "flush" do

    end

    context "full house" do

    end

    context "quads" do

    end

    context "straight flush" do

    end

    context "royal flush" do

    end
  end
end
