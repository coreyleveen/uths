require "spec_helper"

RSpec.describe Round do
  let(:round) { Round.new(player: player, dealer: dealer) }
  let(:player) { Player.new(chips: 5_000, strategy: Strategy.new) }
  let(:dealer) { Dealer.new }

  describe "#run!" do
    subject { round.run! }
  end

  describe "#pot" do
    context "when the player bets before the flop" do
    end
  end
end
