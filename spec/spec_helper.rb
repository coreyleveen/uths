require "bundler/setup"
require "rspec/collection_matchers"
require "rspec/its"
require "pry"

require "uths"
require "uths/deck"
require "uths/hand"
require "uths/player"
require "uths/strategy"
require "uths/dealer"
require "uths/round"


Deck.new.shuffle.each do |card|
  meth = card.to_s.downcase.gsub(" ", "_")
  define_method(meth) { card }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
