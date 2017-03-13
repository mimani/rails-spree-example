require "statsd-ruby"

ENV['STATSD_HOST'] ||= 'localhost'
ENV['STATSD_PORT'] ||= '8125'

module MyStatsd
  def self.statsd
    @statsd ||= Statsd.new(ENV['STATSD_HOST'], ENV['STATSD_PORT'])
  end

  class Middleware
    attr_accessor :app

    def initialize(app)
      @app = app
    end

    def call(env)
      (status, headers, body), response_time = call_with_timing(env)
      puts "in middleware, path is: #{env['REQUEST_PATH']}"
      statsd.timing("#{env['REQUEST_PATH']}.response", response_time)
      statsd.increment("#{env['REQUEST_PATH']}.response_codes.#{status.to_s.gsub(/\d{2}$/,'xx')}")
      # Rack response
      [status, headers, body]
    rescue Exception => exception
      statsd.increment("#{env['REQUEST_PATH']}.response_codes.5xx")
      raise
    end

    def call_with_timing(env)
      start = Time.now
      result = @app.call(env)
      [result, ((Time.now - start) * 1000).round]
    end

    def statsd
      MyStatsd.statsd
    end
  end
end
