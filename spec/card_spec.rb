require "spec_helper"

RSpec.describe Card do
  let(:card) { Card.new(suit: "Spades", rank: 14) }

  describe "#suit" do
    subject { card.suit }

    it { is_expected.to eq("spades") }
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

      it { is_expected.to eq("Five of Hearts") }
    end
  end

  describe "#<=>" do
    let(:queen) { Card.new(suit: "hearts", rank: 12) }
    let(:jack)  { Card.new(suit: "hearts", rank: 11) }
    let(:other_queen) { Card.new(suit: "clubs", rank: 12) }

    it { expect(queen).to be > jack }
    it { expect(jack).to be < queen }
    it { expect(other_queen).to eq(queen) }
  end

  describe "rank methods" do
    subject { card.two? }

    context "when the card has a rank of two" do
      let(:card) { Card.new(suit: "spades", rank: 2) }

      it { is_expected.to eq(true) }
    end

    context "when the card does not have a rank of two" do
      it { is_expected.to eq(false) }
    end

    context "without the question mark" do
      subject { card.two }

      let(:card) { Card.new(suit: "spades", rank: 2) }

      it { is_expected.to eq(true) }
    end
  end

  describe "card methods" do
    subject { card.queen_of_spades? }

    context "when the card is a queen of spades" do
      let(:card) { Card.new(suit: "spades", rank: 12) }

      it { is_expected.to eq(true) }
    end

    context "when the card is not a queen of spades" do
      let(:card) { Card.new(suit: "spades", rank: 10) }

      it { is_expected.to eq(false) }
    end
  end
end
