require "spec_helper"

RSpec.describe Strategy do
  describe "#bet?" do
    subject { strategy.bet? }

    let(:strategy) { Strategy.new }
    let(:hand) { Hand.call(cards) }

    before { strategy.hand = hand }

    context "pre-flop" do
      context "suited" do
        context "king high" do
          let(:cards) { [king_of_diamonds, two_of_diamonds] }

          it { is_expected.to eq(true) }
        end

        context "queen high" do
          let(:cards) { [queen_of_diamonds, six_of_diamonds] }

          it { is_expected.to eq(true) }

          context "with low card" do
            let(:cards) { [queen_of_diamonds, five_of_diamonds] }

            it { is_expected.to eq(false) }
          end
        end

        context "jack high" do
          let(:cards) { [jack_of_diamonds, eight_of_diamonds] }

          it { is_expected.to eq(true) }

          context "with low card" do
            let(:cards) { [jack_of_diamonds, seven_of_diamonds] }

            it { is_expected.to eq(false) }
          end
        end
      end

      context "unsuited" do
        context "ace high" do
          let(:cards) { [ace_of_diamonds, two_of_spades] }

          it { is_expected.to eq(true) }
        end

        context "king high" do
          let(:cards) { [king_of_diamonds, five_of_spades] }

          it { is_expected.to eq(true) }

          context "with low card" do
            let(:cards) { [king_of_diamonds, four_of_spades] }

            it { is_expected.to eq(false) }
          end
        end

        context "queen high" do
          let(:cards) { [queen_of_diamonds, eight_of_spades] }

          it { is_expected.to eq(true) }

          context "with low card" do
            let(:cards) { [queen_of_diamonds, seven_of_spades] }

            it { is_expected.to eq(false) }
          end
        end

        context "jack high" do
          let(:cards) { [jack_of_diamonds, ten_of_spades] }

          it { is_expected.to eq(true) }

          context "with low card" do
            let(:cards) { [jack_of_diamonds, nine_of_spades] }

            it { is_expected.to eq(false) }
          end
        end
      end

      context "pair" do
        context "when at or above given value" do
          let(:cards) { [three_of_diamonds, three_of_spades] }

          it { is_expected.to eq(true) }
        end

        context "when below given value" do
          let(:cards) { [two_of_diamonds, two_of_spades] }

          it { is_expected.to eq(false) }
        end
      end
    end

    context "flop" do
      let(:cards) { pocket + table_cards }

      context "when there is a two pair or better" do
        let(:pocket) { [five_of_spades, six_of_diamonds] }
        let(:table_cards) { [six_of_diamonds, five_of_spades, jack_of_diamonds] }

        it { is_expected.to eq(true) }
      end

      context "when there is not a two pair or better" do
        let(:pocket) { [five_of_spades, six_of_diamonds] }
        let(:table_cards) { [eight_of_spades, nine_of_hearts, jack_of_diamonds] }

        it { is_expected.to eq(false) }
      end

      context "when there is a hidden pair" do
        let(:table_cards) { [five_of_spades, six_of_diamonds, nine_of_hearts] }

        context "and it's a pocket pair" do
          let(:pocket) { [three_of_spades, three_of_clubs] }

          it { is_expected.to eq(true) }

          context "and it's pocket deuces" do
            let(:pocket) { [two_of_spades, two_of_clubs] }

            it { is_expected.to eq(false) }
          end
        end

        context "and it's not a pocket pair" do
          let(:pocket) { [five_of_diamonds, three_of_clubs] }

          it { is_expected.to eq(true) }
        end
      end

      context "when there is a shared pair only" do
        let(:pocket) { [three_of_clubs, four_of_spades] }
        let(:table_cards) { [eight_of_spades, eight_of_diamonds, nine_of_hearts] }

        it { is_expected.to eq(false) }
      end

      context "four to a flush" do
        let(:table_cards) { [four_of_clubs, eight_of_clubs, two_of_clubs] }

        context "with a hidden ten or better to the flush" do
          let(:pocket) { [three_of_spades, ten_of_clubs] }

          it { is_expected.to eq(true) }
        end

        context "without a hidden ten or better to the flush" do
          let(:pocket) { [three_of_spades, nine_of_clubs] }

          it { is_expected.to eq(false) }
        end
      end
    end

    context "river" do
      let(:cards) { pocket + table_cards }
      let(:table_cards) do
        [
          two_of_spades,
          nine_of_diamonds,
          six_of_clubs,
          queen_of_spades,
          eight_of_hearts
        ]
      end

      context "with a hidden pair" do
        let(:pocket) { [two_of_diamonds, five_of_hearts] }

        it { is_expected.to eq(true) }
      end

      context "with a two pair or better" do
        let(:pocket) { [two_of_diamonds, six_of_hearts] }

        it { is_expected.to eq(true) }
      end

      context "with less than 21 outs" do
        let(:pocket) { [king_of_diamonds, ace_of_hearts] }

        it { is_expected.to eq(true) }
      end

      context "with none of the above" do
        let(:pocket) { [six_of_spades, nine_of_diamonds] }
        let(:table_cards) do
          [
            king_of_clubs,
            seven_of_spades,
            two_of_spades,
            ace_of_spades,
            ten_of_clubs
          ]
        end

        it { is_expected.to eq(false) }
      end
    end
  end
end
