class Logger
  LOG_FILENAME = "log"

  class << self
    def log(text)
      File.open(LOG_FILENAME, ?a) { |f| f.puts(text) }
    end
  end
end
