require "spec_helper"

RSpec.describe Hand do
  describe ".call" do
    subject { Hand.call(cards) }

    let(:cards) { pocket + table_cards }
    let(:pocket) { [ten_of_hearts, nine_of_hearts] }
    let(:table_cards) { [] }

    it { is_expected.to be_kind_of(Hand) }

    context "high card" do
      its(:type) { is_expected.to eq(:high_card) }
      its(:best) { is_expected.to eq([ten_of_hearts]) }
      its(:rest) { is_expected.to eq([nine_of_hearts]) }
    end

    context "pair" do
      let(:table_cards) { [nine_of_diamonds, queen_of_diamonds, ace_of_hearts, two_of_hearts, five_of_clubs] }

      its(:type) { is_expected.to eq(:pair) }
      its(:best) { is_expected.to eq([nine_of_spades, nine_of_diamonds]) }
      its(:rest) { is_expected.to eq([ace_of_hearts, queen_of_diamonds, ten_of_hearts, five_of_clubs, two_of_hearts]) }
    end

    context "two pair" do
      let(:table_cards) { [nine_of_diamonds, ten_of_spades, two_of_hearts, queen_of_diamonds, ace_of_hearts] }

      its(:type) { is_expected.to eq(:two_pair) }
      its(:best) { is_expected.to eq([ten_of_hearts, ten_of_spades, nine_of_spades, nine_of_diamonds, ace_of_hearts]) }
      its(:rest) { is_expected.to eq([queen_of_diamonds, two_of_hearts]) }
    end

    context "trips" do
      let(:pocket) { [king_of_diamonds, king_of_spades] }
      let(:table_cards) { [king_of_clubs, eight_of_hearts, three_of_clubs, two_of_hearts, five_of_spades] }

      its(:type) { is_expected.to eq(:trips) }
      its(:best) { is_expected.to eq([king_of_diamonds, king_of_clubs, king_of_spades, eight_of_hearts, five_of_spades]) }
      its(:rest) { is_expected.to eq([three_of_clubs, two_of_hearts]) }
    end

    context "straight" do
      let(:pocket) { [two_of_clubs, three_of_hearts] }
      let(:table_cards) { [ace_of_spades, four_of_diamonds, five_of_clubs, six_of_diamonds, seven_of_hearts] }

      its(:type) { is_expected.to eq(:straight) }
      its(:best) { is_expected.to eq([three_of_hearts, four_of_diamonds, five_of_clubs, six_of_diamonds, seven_of_hearts]) }
      its(:rest) { is_expected.to eq([ace_of_spades, two_of_clubs]) }
    end

    context "flush" do
      let(:pocket) { [king_of_diamonds, ace_of_diamonds] }
      let(:table_cards) { [three_of_clubs, four_of_diamonds, eight_of_spades, five_of_diamonds, two_of_diamonds] }

      its(:type) { is_expected.to eq(:flush) }
      its(:best) { is_expected.to eq([ace_of_diamonds, king_of_diamonds, five_of_diamonds, four_of_diamonds, two_of_diamonds]) }
      its(:rest) { is_expected.to eq([eight_of_spades, three_of_clubs]) }
    end

    context "full house" do
      let(:pocket) { [two_of_spades, three_of_clubs] }
      let(:table_cards) { [two_of_diamonds, three_of_spades, three_of_hearts, queen_of_diamonds, queen_of_hearts] }

      its(:type) { is_expected.to eq(:full_house) }
      its(:best) { is_expected.to eq([three_of_spades, three_of_hearts, three_of_clubs, queen_of_diamonds, queen_of_hearts]) }
      its(:rest) { is_expected.to eq([two_of_spades, two_of_diamonds]) }
    end

    context "quads" do
      let(:pocket) { [three_of_diamonds, eight_of_hearts] }
      let(:table_cards) { [three_of_spades, three_of_clubs, three_of_hearts, jack_of_clubs, king_of_spades] }

      its(:type) { is_expected.to eq(:quads) }
      its(:best) { is_expected.to eq([three_of_spades, three_of_clubs, three_of_diamonds, three_of_hearts, king_of_spades]) }
      its(:rest) { is_expected.to eq([jack_of_clubs, eight_of_hearts]) }
    end

    context "straight flush" do
      let(:pocket) { [ace_of_spades, two_of_spades] }
      let(:table_cards) { [three_of_spades, four_of_spades, five_of_spades, six_of_spades, ten_of_hearts] }

      its(:type) { is_expected.to eq(:straight_flush) }
      its(:best) { is_expected.to eq([two_of_spades, three_of_spades, four_of_spades, five_of_spades, six_of_spades]) }
      its(:rest) { is_expected.to eq([ace_of_spades, ten_of_hearts]) }
    end

    context "royal flush" do
      let(:pocket) { [ten_of_hearts, jack_of_hearts] }
      let(:table_cards) { [queen_of_hearts, ace_of_hearts, king_of_hearts, eight_of_diamonds, four_of_clubs] }

      its(:type) { is_expected.to eq(:royal_flush) }
      its(:best) { is_expected.to eq([ace_of_hearts, king_of_hearts, queen_of_hearts, jack_of_hearts, ten_of_hearts]) }
      its(:rest) { is_expected.to eq([eight_of_diamonds, four_of_clubs]) }
    end
  end

  describe "#<=>" do
    let(:hand_a) { Hand.call(straight) }
    let(:hand_b) { Hand.call(trips) }

    let(:straight) { [five_of_clubs, six_of_spades, seven_of_hearts, eight_of_diamonds, nine_of_clubs, jack_of_hearts, ace_of_spades] }
    let(:trips) { [five_of_spades, five_of_diamonds, five_of_hearts, eight_of_diamonds, ten_of_diamonds] }

    it { expect(hand_a).to be > hand_b }

    context "when the hands are the same type" do
      let(:hand_a) { Hand.call(high_straight) }
      let(:hand_b) { Hand.call(low_straight) }

      let(:high_straight) { [nine_of_diamonds, two_of_clubs] + table_cards }
      let(:low_straight) { [three_of_hearts, jack_of_diamonds] + table_cards }
      let(:table_cards) { [four_of_spades, five_of_diamonds, six_of_hearts, seven_of_clubs, eight_of_spades] }

      it { expect(hand_a).to be > hand_b }

      context "and the kicker matters" do
        let(:hand_a) { Hand.call(two_pair) }
        let(:hand_b) { Hand.call(other_two_pair) }

        let(:two_pair) { [five_of_hearts, king_of_diamonds] + table_cards }
        let(:other_two_pair) { [five_of_spades, king_of_hearts] + table_cards }
        let(:table_cards) { [three_of_hearts, three_of_clubs, five_of_clubs, nine_of_hearts, queen_of_clubs] }

        context "and the kicker is the same rank" do
          it { expect(hand_a).to eq(hand_b) }
        end

        context "and the kicker is a different rank" do
          let(:other_two_pair) { [five_of_spades, eight_of_clubs] + table_cards }

          it { expect(hand_a).to be > hand_b }
        end
      end

      context "and the max card value cannot be used to determine hand strength" do
        let(:hand_a) { Hand.call(high_full_house) }
        let(:hand_b) { Hand.call(low_full_house) }

        let(:high_full_house) { [ten_of_hearts, ten_of_diamonds] + table_cards }
        let(:low_full_house) { [ace_of_diamonds, ace_of_spades] + table_cards }
        let(:table_cards) { [two_of_spades, two_of_clubs, two_of_diamonds, ten_of_spades, eight_of_clubs] }

        it { expect(hand_a).to be > hand_b }
      end
    end
  end

  describe "#pre_flop?" do
    subject { hand.pre_flop? }

    let(:hand) { Hand.call(cards) }

    context "when the hand has two cards" do
      let(:cards) { [ace_of_spades, two_of_hearts] }

      it { is_expected.to eq(true) }
    end

    context "when the hand has more than two cards" do
      let(:cards) { [ace_of_spades, two_of_hearts, three_of_clubs, eight_of_diamonds, nine_of_spades] }

      it { is_expected.to be(false) }
    end
  end

  describe "#flop?" do
    subject { hand.flop? }

    let(:hand) { Hand.call(cards) }

    context "when the hand has five cards" do
      let(:cards) { [ace_of_spades, two_of_hearts, three_of_clubs, eight_of_diamonds, nine_of_spades] }

      it { is_expected.to eq(true) }
    end

    context "when the hand has more than five cards" do
      let(:cards) do
        [
          ace_of_spades,
          two_of_hearts,
          three_of_clubs,
          eight_of_diamonds,
          nine_of_spades,
          four_of_diamonds,
          ten_of_spades
        ]
      end

      it { is_expected.to eq(false) }
    end
  end

  describe "#river?" do
    subject { hand.river? }

    let(:hand) { Hand.call(cards) }

    context "when the hand has seven cards" do
      let(:cards) do
        [
          ace_of_spades,
          two_of_hearts,
          three_of_clubs,
          eight_of_diamonds,
          nine_of_spades,
          four_of_diamonds,
          ten_of_spades
        ]
      end

      it { is_expected.to eq(true) }
    end

    context "when the hand has less than seven cards" do
      let(:cards) do
        [
          ace_of_spades,
          two_of_hearts,
          three_of_clubs,
          nine_of_spades,
          ten_of_spades
        ]
      end

      it { is_expected.to eq(false) }
    end
  end
end
