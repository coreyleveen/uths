require "spec_helper"

RSpec.describe Card do
  let(:card) { Card.new(suit: "Spades", rank: 14) }

  describe "#suit" do
    subject { card.suit }

    it { is_expected.to eq("Spades") }
  end

  describe "#rank" do
    subject { card.rank }

    it { is_expected.to eq(14) }
  end

  describe "#to_s" do
    subject { card.to_s }

    it { is_expected.to eq("Ace of Spades") }

    context "when the rank is a non-face card" do
      let(:card) { Card.new(suit: "Hearts", rank: 5) }

      it { is_expected.to eq("5 of Hearts") }
    end
  end
end
