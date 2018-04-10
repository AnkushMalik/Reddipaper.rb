require 'open-uri'
require 'nokogiri'

if !ARGV.empty?
	redditscrape = Nokogiri::HTML(open("https://www.reddit.com/r/#{ARGV[0]}", 'User-Agent' => 'Nooby'))
else
	redditscrape = Nokogiri::HTML(open("https://www.reddit.com/r/wallpaper/#{ARGV[0]}", 'User-Agent' => 'Nooby'))
end

def choose_wp redditscrape
	a = rand(0..redditscrape.css('.thing').size)
	wallobj = redditscrape.css('.thing')[a]
	wp_path = wallobj.css('.bylink').first.attributes['href'].value
	wppage = Nokogiri::HTML(open(wp_path, 'User-Agent' => 'Nooby'))
	if !wppage.css('.preview').size
		puts "404!, retrying..."
		choose_wp redditscrape
	else
		# For low quality images
		# wp_link = wppage.css('.preview').first.attributes['src'].value
		wp_link = wppage.css('.media-preview-content a').first.attributes['href'].value
		set_wp wp_link
	end
end

def set_wp wp_link
	open(wp_link) { |f|
		File.open('wallpaper.jpeg','wb')  do |file|
			file.puts f.read
		end
	}
	puts system 'gsettings set org.gnome.desktop.background picture-uri file://' + Dir.pwd + '/wallpaper.jpeg'	
end

while true
	choose_wp redditscrape
	sleep 120
end
