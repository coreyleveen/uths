require "spec_helper"

RSpec.describe Hand do
  let(:hand) { Hand.new(cards) }

  describe "#best_hand" do
    subject { hand.best_hand }

    let(:cards) { pocket + table_cards }

    xcontext "high card" do
      let(:pocket) { [ten_of_hearts, nine_of_hearts] }

      context "pre-flop" do
        let(:table_cards) { [] }

        it { is_expected.to eq(high_card: ten_of_hearts, rest: [nine_of_hearts]) }
      end

      context "flop" do
        let(:table_cards) { [four_of_clubs, two_of_spades, ace_of_hearts] }
        let(:high_card) do
          {
            high_card: ace_of_hearts,
            rest: [ten_of_hearts, nine_of_hearts, four_of_clubs, two_of_spades]
          }
        end

        it { is_expected.to eq(high_card) }
      end

      context "river" do
        let(:table_cards) do
          [
            four_of_clubs,
            two_of_spades,
            ace_of_hearts,
            six_of_diamonds,
            jack_of_clubs
          ]
        end
        let(:high_card) do
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

        it { is_expected.to eq(high_card) }
      end
    end

    context "pair" do
      let(:pocket) { [nine_of_spades, eight_of_clubs] }
      let(:table_cards) do
        [
          nine_of_diamonds,
          queen_of_diamonds,
          ace_of_hearts,
          two_of_hearts,
          five_of_clubs
        ]
      end
      let(:pair) do
        {
          pair: [nine_of_spades, nine_of_diamonds],
          rest: [
            ace_of_hearts,
            queen_of_diamonds,
            eight_of_clubs,
            five_of_clubs,
            two_of_hearts
          ]
        }
      end

      it { is_expected.to eq(pair) }
    end

    context "two pair" do
      let(:pocket) { [nine_of_spades, eight_of_clubs] }
      let(:table_cards) do
        [
          nine_of_diamonds,
          eight_of_spades,
          two_of_hearts,
          queen_of_diamonds,
          ace_of_hearts
        ]
      end
      let(:two_pair) do
        {
          two_pair: [
            nine_of_spades,
            nine_of_diamonds,
            eight_of_spades,
            eight_of_clubs
          ],
          rest: [ace_of_hearts, queen_of_diamonds, two_of_hearts]
        }
      end

      it { is_expected.to eq(two_pair) }
    end

    context "trips" do
      let(:pocket) { [king_of_diamonds, king_of_spades] }
      let(:table_cards) do
        [
          king_of_clubs,
          eight_of_hearts,
          three_of_clubs,
          two_of_hearts,
          five_of_spades
        ]
      end
      let(:trips) do
        {
          trips: [
            king_of_diamonds,
            king_of_clubs,
            king_of_spades,
            eight_of_hearts,
            five_of_spades
          ],
          rest: [three_of_clubs, two_of_hearts]
        }
      end

      it { is_expected.to eq(trips) }
    end

    context "straight" do
      let(:pocket) { [two_of_clubs, three_of_hearts] }

      context "flop" do
        let(:table_cards) { [ace_of_spades, four_of_diamonds, five_of_clubs] }
        let(:straight) do
          {
            straight: [
              two_of_clubs,
              three_of_hearts,
              four_of_diamonds,
              five_of_clubs,
              ace_of_spades
            ],
            rest: []
          }
        end

        it { is_expected.to eq(straight) }
      end

      context "river" do
        let(:table_cards) do
          [
            ace_of_spades,
            four_of_diamonds,
            five_of_clubs,
            six_of_diamonds,
            seven_of_hearts
          ]
        end
        let(:straight) do
          {
            straight: [
              three_of_hearts,
              four_of_diamonds,
              five_of_clubs,
              six_of_diamonds,
              seven_of_hearts
            ],
            rest: [ace_of_spades, two_of_clubs]
          }
        end

        it { is_expected.to eq(straight) }
      end
    end

    context "flush" do
      let(:pocket) { [king_of_diamonds, ace_of_diamonds] }
      let(:table_cards) do
        [
          three_of_clubs,
          four_of_diamonds,
          eight_of_spades,
          five_of_diamonds,
          two_of_diamonds
        ]
      end
      let(:flush) do
        {
          flush: [
            ace_of_diamonds,
            king_of_diamonds,
            five_of_diamonds,
            four_of_diamonds,
            two_of_diamonds
          ],
          rest: [eight_of_spades, three_of_clubs]
        }
      end

      it { is_expected.to eq(flush) }
    end

    context "full house" do
      let(:pocket) { [two_of_spades, three_of_clubs] }

      context "flop" do
        let(:table_cards) { [two_of_diamonds, three_of_spades, three_of_hearts] }
        let(:full_house) do
          {
            full_house: [
              three_of_spades,
              three_of_hearts,
              three_of_clubs,
              two_of_spades,
              two_of_diamonds
            ],
            rest: []
          }
        end

        it { is_expected.to eq(full_house) }
      end

      context "river" do
        let(:table_cards) do
          [
            two_of_diamonds,
            three_of_spades,
            three_of_hearts,
            queen_of_diamonds,
            queen_of_hearts
          ]
        end
        let(:full_house) do
          {
            full_house: [
              three_of_spades,
              three_of_hearts,
              three_of_clubs,
              queen_of_diamonds,
              queen_of_hearts
            ],
            rest: [two_of_spades, two_of_diamonds]
          }
        end

        it { is_expected.to eq(full_house) }
      end
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
              two_of_spades,
              three_of_spades,
              four_of_spades,
              five_of_spades,
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
