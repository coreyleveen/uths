require "spec_helper"

RSpec.describe Hand do
  let(:hand) { Hand.new(cards) }

  describe "#best_hand" do
    subject { hand.best_hand }

    let(:pocket) { [ten_of_hearts, nine_of_hearts] }
    let(:cards) { pocket + table_cards }

    xcontext "high card" do
      context "pre-flop" do
        let(:table_cards) { [] }

        it { is_expected.to eq(high_card: ten_of_hearts, rest: [nine_of_hearts]) }
      end

      context "flop" do
        let(:table_cards) { [four_of_clubs, two_of_spades, ace_of_hearts] }
        let(:expected) do
          {
            high_card: ace_of_hearts,
            rest: [ten_of_hearts, nine_of_hearts, four_of_clubs, two_of_spades]
          }
        end

        it { is_expected.to eq(expected) }
      end

      context "river" do
        let(:table_cards) do
          [four_of_clubs, two_of_spades, ace_of_hearts, six_of_diamonds, jack_of_clubs]
        end

        let(:expected) do
          {
            high_card: ace_of_hearts,
            rest: [
              jack_of_clubs,
              ten_of_hearts,
              nine_of_hearts,
              six_of_diamonds,
              four_of_clubs,
              two_of_spades
            ]
          }
        end
      end
    end

    context "pair" do
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
      let(:pocket) { [three_of_diamonds, eight_of_hearts] }
      let(:table_cards) do
        [
          three_of_spades,
          three_of_clubs,
          three_of_hearts,
          jack_of_clubs,
          king_of_spades
        ]
      end
      let(:quads) do
        {
          quads: [
            three_of_spades,
            three_of_clubs,
            three_of_diamonds,
            three_of_hearts,
            king_of_spades
          ],
          rest: [jack_of_clubs, eight_of_hearts]
        }
      end

      it { is_expected.to eq(quads) }
    end

    context "straight flush" do
      let(:pocket) { [ace_of_spades, two_of_spades] }

      context "flop" do
        let(:table_cards) { [three_of_spades, four_of_spades, five_of_spades] }
        let(:straight_flush) do
          {
            straight_flush: [
              five_of_spades,
              four_of_spades,
              three_of_spades,
              two_of_spades,
              ace_of_spades
            ],
            rest: []
          }
        end

        it { is_expected.to eq(straight_flush) }
      end

      context "river" do
        let(:table_cards) do
          [
            three_of_spades,
            four_of_spades,
            five_of_spades,
            six_of_spades,
            ten_of_hearts
          ]
        end

        let(:straight_flush) do
          {
            straight_flush: [
              two_of_spades,
              three_of_spades,
              four_of_spades,
              five_of_spades,
              six_of_spades
            ],
            rest: [ace_of_spades, ten_of_hearts]
          }
        end

        it { is_expected.to eq(straight_flush) }
      end
    end

    context "royal flush" do
      let(:pocket) { [ten_of_hearts, jack_of_hearts] }

      context "flop" do
        let(:table_cards) { [queen_of_hearts, ace_of_hearts, king_of_hearts] }
        let(:royal_flush) do
          {
            royal_flush: [
              ace_of_hearts,
              king_of_hearts,
              queen_of_hearts,
              jack_of_hearts,
              ten_of_hearts
            ],
            rest: []
          }
        end

        it { is_expected.to eq(royal_flush) }
      end

      context "river" do
        let(:table_cards) do
          [
            queen_of_hearts,
            ace_of_hearts,
            king_of_hearts,
            eight_of_diamonds,
            four_of_clubs
          ]
        end

        let(:royal_flush) do
          {
            royal_flush: [
              ace_of_hearts,
              king_of_hearts,
              queen_of_hearts,
              jack_of_hearts,
              ten_of_hearts
            ],
            rest: [eight_of_diamonds, four_of_clubs]
          }
        end

        it { is_expected.to eq(royal_flush) }
      end
    end
  end
end
