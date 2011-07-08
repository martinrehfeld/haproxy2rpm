module Haproxy2Rpm
  class FileParser

    include Enumerable

    def initialize(path)
      @lines = File.open(path){|f| f.readlines}
      @records = []
      @lines.each do |line|
        @records << LineParser.new(line)
      end
    end

    def [](element)
      @records
    end

    def each &block
      @records.each do |record|
        yield record
      end
    end
  end
end
