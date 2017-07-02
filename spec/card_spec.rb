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

  describe "#<=>" do
    let(:queen) { Card.new(suit: "Hearts", rank: 12) }
    let(:jack)  { Card.new(suit: "Hearts", rank: 11) }

    it { expect(queen).to be > jack }
    it { expect(jack).to be < queen }
  end
end
