require 'open-uri'
require 'nokogiri'


redditscrape = Nokogiri::HTML(open('https://www.reddit.com/r/wallpapers/', 'User-Agent' => 'Nooby'))

a = rand(0..redditscrape.css('.thing').size)
wallobj = redditscrape.css('.thing')[a]
wp_path = wallobj.css('.bylink').first.attributes['href'].value
wppage = Nokogiri::HTML(open(wp_path, 'User-Agent' => 'Nooby'))
if !wppage.css('.preview').size
	puts '404!'
end

wp_link = wppage.css('.preview').first.attributes['src'].value

open(wp_link) { |f|
	File.open('wallpaper.png','wb')  do |file|
		file.puts f.read
	end
}

puts system 'gsettings set org.gnome.desktop.background picture-uri file://'+Dir.pwd+'/wallpaper.png'

