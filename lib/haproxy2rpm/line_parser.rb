module Haproxy2Rpm
  class LineParser

    def initialize(line)
      @line = line
      @parts = line.split("\s")
    end

    def tq
      @tw ||= response_times[0].to_i
    end

    def tw
      @tw ||= response_times[1].to_i
    end

    def tc
      @tc ||= response_times[2].to_i
    end

    def tr
      @tr ||= response_times[3].to_i
    end

    def tt
      @tt ||= response_times[4].to_i
    end

    def status_code
      @status_code ||= @parts[6].to_i
    end

    # we need to chop \"
    def http_method
      @http_method ||= @parts[13][1..-1]
    end

    def uri
      @uri ||= @parts[14]
    end

    private

    def response_times
      @response_times ||= @parts[5].split("/")
    end
  end
end
