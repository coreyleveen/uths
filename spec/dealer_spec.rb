require "spec_helper"

RSpec.describe Dealer do
  let(:dealer) { Dealer.new }
  let(:player) { Player.new(chips: 5_000) }

  before { dealer.player = player }

  describe "#hand" do
    subject { dealer.hand }

    before { dealer.hand = hand }

    let(:hand) { Hand.call(cards) }
    let(:cards) { [ten_of_hearts, nine_of_hearts] }

    it { is_expected.to eq(hand) }
  end

  describe "#player" do
    subject { dealer.player }

    it { is_expected.to eq(player) }
  end

  describe "#cards" do
    subject { dealer.cards }

    its(:count) { is_expected.to eq(52) }
    its(:first) { is_expected.to be_kind_of(Card) }
  end

  describe "#deal_pocket" do
    subject { -> { dealer.deal_pocket } }

    it { is_expected.to change { dealer.hand }.to kind_of(Hand) }
    it { is_expected.to change { player.hand }.to kind_of(Hand) }

    it "deals only two cards" do
      subject.call

      expect(dealer.hand.cards.count).to eq(2)
      expect(player.hand.cards.count).to eq(2)
    end

    it { is_expected.to change { dealer.cards.count }.from(52).to(48) }

    context "when dealing the player specific cards" do
      subject { -> { dealer.deal_pocket(cards) } }

      let(:cards) { %i(king_of_spades two_of_spades) }

      it do
        subject.call

        expect(player.hand.cards.max).to be_king_of_spades
        expect(player.hand.cards.min).to be_two_of_spades

        expect(dealer.cards.count).to eq(48)
      end
    end
  end

  describe "#deal_flop" do
    subject { -> { dealer.deal_flop } }

    before { dealer.deal_pocket }

    it { is_expected.to change { dealer.cards.count }.from(48).to(45) }

    it { is_expected.to change { dealer.hand.size }.from(2).to(5) }
    it { is_expected.to change { player.hand.size }.from(2).to(5) }
  end

  describe "#deal_river" do
    subject { -> { dealer.deal_river } }

    before { dealer.deal_pocket; dealer.deal_flop }

    it { is_expected.to change { dealer.cards.count }.from(45).to(43) }

    it { is_expected.to change { dealer.hand.size }.from(5).to(7) }
    it { is_expected.to change { player.hand.size }.from(5).to(7) }
  end

  describe "#qualifies?" do
    subject { dealer.qualifies? }

    before { dealer.hand = hand }

    let(:hand) { Hand.call(cards) }

    context "when the dealer has a pair or better" do
      let(:cards) { [ten_of_hearts, ten_of_diamonds] }

      it { is_expected.to eq(true) }
    end

    context "when the dealer has a high-card hand" do
      let(:cards) { [ten_of_hearts, nine_of_diamonds] }

      it { is_expected.to eq(false) }
    end
  end
end
