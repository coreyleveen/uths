require "spec_helper"

RSpec.describe Strategy do
  describe "#bet?" do
    subject { strategy.bet? }

    let(:strategy) { Strategy.new(config) }
    let(:hand) { Hand.call(cards) }
    let(:config) do
      {
        pre_flop: {
          suited: { king: 2, queen: 6, jack: 8 },
          unsuited: {
            ace: 2,
            king: 5,
            queen: 8,
            jack: 10
          },
          pair: 3
        }
      }
    end

    before { strategy.hand = hand }

    context "pre flop" do
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

    xcontext "flop" do

    end

    xcontext "river" do

    end
  end
end
