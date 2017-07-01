require "spec_helper"

RSpec.describe Deck do
  describe "#shuffle" do
    subject { deck.shuffle }

    let(:deck) { Deck.new }

    it { is_expected.to have(52).items }
    it { expect(subject.first).to be_kind_of(Card) }
  end
end
