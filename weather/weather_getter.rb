#!/usr/bin/env ruby

require 'logger'
require 'net/http'
require 'nokogiri'
require 'pry'
require './weather_report'

$log = Logger.new('./weather.log', 'weekly')

class WeatherGetter
  def initialize
    ActiveRecord::Base.establish_connection(
      :adapter => :postgresql,
      :database => 'weather'
    )
  end

  def fetch_latest(code)
    uri = URI("http://forecast.weather.gov/product.php?site=#{code}&issuedby=#{code}&product=AFD&format=txt&version=1&glossary=0")
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      doc = Nokogiri::HTML(res.body)
      $log.info("#{res.code} #{res.message}")
      raw_report = doc.css('.glossaryProduct').first.text
      w = WeatherReport.create(:site_code => code, :forecaster_discussion => raw_report)
      if w
        $log.info("saved weather report, length #{raw_report.length}")
      else
        $log.error("couldn't save weather report! raw report length: #{raw_report.length}, errors: #{w.errors}")
      end
    else
      $log.error("#{res.code} #{res.message}")
    end
  end
end

w = WeatherGetter.new
w.fetch_latest('BOU')
