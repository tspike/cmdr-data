require 'digest'
require 'logger'
require 'net/http'
require 'nokogiri'
require 'pry'

require './lib/weather_report'

$log = Logger.new('./log/weather.log', 'weekly')

class WeatherGetter
  def initialize
    ActiveRecord::Base.establish_connection(
      :adapter => :postgresql,
      :database => 'weather'
    )
  end

  def fetch_latest(code)
    uri = URI("http://forecast.weather.gov/product.php?site=#{code}&issuedby=#{code}&product=AFD&format=txt&version=1&glossary=0")
    begin
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        doc = Nokogiri::HTML(res.body)
        $log.info("#{res.code} #{res.message}")
        raw_report = doc.css('.glossaryProduct').first.text
        checksum = Digest::SHA2.base64digest(raw_report) 
        w = WeatherReport.create(:site_code => code, :forecaster_discussion => raw_report, :digest => checksum)
        if w
          $log.info("saved weather report for #{code}, length #{raw_report.length}")
        else
          $log.error("couldn't save weather report for #{code}! raw report length: #{raw_report.length}, errors: #{w.errors}")
        end
      else
        $log.error("#{res.code} #{res.message}")
      end
    rescue Exception => e
      $log.error(e.message)
      $log.error(e.backtrace.inspect)
    end
  end
end
