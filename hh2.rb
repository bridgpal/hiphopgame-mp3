require 'nokogiri'
require 'open-uri'

url = 'http://hiphopgame.ihiphop.com/index2.php3?page=tracks'
player = "http://hiphopgame.ihiphop.com/player.php?id="
href = "http://hiphopgame.ihiphop.com/"


re = /(?<=player.php\?id=).+?(?=\')/
re_song  = /(?<=soundFile:\ ").+?(?=\")/

data = Nokogiri::HTML(open(url)).to_s

def download(fileName, url)
	unless File.exist?(fileName)	
		puts "Downloading: " + fileName 
			open(fileName, "wb") do |file|
			file << open(URI.encode(url.to_s)).read

		end
	end
rescue
	puts "File not found: " + fileName 
end

#remove duplicates
items = data.scan(re).uniq

items.each do |items|
	
	#Construct player URL to open
	player_url = player + items
	player_data = Nokogiri::HTML(open(player_url))
	
	#Use title for mp3 track name
	song = player_data.css("title").text.gsub(" - HipHopGame.com", "")+".mp3"
	
	#Regular Expression to get .mp3 download link
	mp3 = href + (re_song.match player_data).to_s

	download(song,mp3)

	
end