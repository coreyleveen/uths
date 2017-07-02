require "spec_helper"

RSpec.describe Hand do
  let(:hand) { Hand.new(pocket: pocket_cards) }
  let(:pocket_cards) { [card_1, card_2] }
  let(:card_1) { Card.new(suit: "Hearts", rank: 10) }

  describe "#pair?" do
    subject { hand.pair? }

    context "when both cards have the same rank" do
      let(:card_2) { Card.new(suit: "Spades", rank: 10) }

      it { is_expected.to be(true) }
    end

    context "when both cards have differing rank" do
      let(:card_2) { Card.new(suit: "Hearts", rank: 9) }

      it { is_expected.to be(false) }
    end
  end

  describe "#high_card" do
    subject { hand.high_card }

    let(:card_2) { Card.new(suit: "Spades", rank: 13) }

    it { is_expected.to eq(card_2) }
  end
end
