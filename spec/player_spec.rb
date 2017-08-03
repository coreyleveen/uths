require "spec_helper"

RSpec.describe Player do
  let(:player) { Player.new(chips: 5_000, strategy: strategy) }
  let(:strategy) { Strategy.new }

  describe "#chips" do
    subject { player.chips }

    it { is_expected.to eq(5_000) }
  end

  describe "#bet?" do
    subject { player.bet? }

    let(:hand) { Hand.call(cards) }
    let(:cards) { [king_of_hearts, eight_of_spades] }

    before { player.hand = hand }

    context "when the strategy determines a bet should be placed" do
      before { allow(strategy).to receive(:bet?) { true } }

      it { is_expected.to eq(true) }
    end

    context "when the strategy determines a bet should not be placed" do
      before { allow(strategy).to receive(:bet?) { false } }

      it { is_expected.to eq(false) }
    end
  end
end
