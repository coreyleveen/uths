require "spec_helper"

RSpec.describe Logger do
  describe ".log" do
    subject { -> { Logger.log(text) } }

    before do
      File.delete(filename) if File.file?(filename)
    end

    let(:text) { "Testing the logger" }
    let(:filename) { described_class::LOG_FILENAME }
    let(:content) { File.read(filename) }

    it "writes to a file" do
      subject.call
      expect(content).to eq("Testing the logger\n")
    end

    it "adds subsequent loggings to a new line" do
      2.times { subject.call }
      expect(content).to eq("Testing the logger\nTesting the logger\n")
    end

    after { File.delete(filename) }
  end
end
