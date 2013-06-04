#!/usr/bin/env ruby

require './lib/weather_getter'

w = WeatherGetter.new
w.fetch_latest('BOU')
w.fetch_latest('GJT')
w.fetch_latest('PUB')
