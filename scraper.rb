require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'fileutils'

BASE_URL = 'http://www.metoffice.gov.uk/public/weather/forecast/five-day'
WEATHER_DIR = 'weather'
FileUtils.makedirs(WEATHER_DIR) unless File.exists?(WEATHER_DIR)

index_page = Nokogiri::HTML(open(BASE_URL, :allow_redirections => :safe))

weather_titles = index_page.css('table#mapLocations tbody tr')
row = weather_titles.css('td a')
weather = weather_titles.css('td:nth-child(2)')

city = []
forecast = []

row.each { |place|  city << place.content }
weather.each { |prediction| forecast << prediction.content}

i = 0
loop do 
  puts "City: #{city[i]} Forecast: #{forecast[i]}"
  File.open("#{WEATHER_DIR}/#{city[i]}.txt", "w") { |file| file.puts "City: #{city[i]} Forecast: #{forecast[i]}" }
  i += 1
  
  break if i >= city.length
end