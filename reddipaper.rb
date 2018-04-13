require 'open-uri'
require 'nokogiri'
require 'optparse'

cloptions = {}

optparse = OptionParser.new do|opts|
  cloptions[:thread] = nil
  opts.on( '-th', '--thread var' ) do |var|
    cloptions[:thread] = var
  end
  cloptions[:clock] = nil
  opts.on( '-c', '--clock var' ) do |var|
    cloptions[:clock] = var
  end
end

optparse.parse!

if cloptions[:thread]
	redditscrape = Nokogiri::HTML(open("https://www.reddit.com/r/#{cloptions[:thread]}", 'User-Agent' => 'Nooby'))
else
	redditscrape = Nokogiri::HTML(open("https://www.reddit.com/r/wallpaper", 'User-Agent' => 'Nooby'))
end

def choose_wp redditscrape
	a = rand(0..redditscrape.css('.thing').size-1)
	wallobj = redditscrape.css('.thing')[a]
	wp_path = wallobj.css('.bylink').first.attributes['href'].value
	wppage = Nokogiri::HTML(open(wp_path, 'User-Agent' => 'Nooby'))
	if !wppage.css('.preview').size or !wppage.css('.media-preview-content a').first
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
	if cloptions[:clock]
		sleep cloptions[:clock].to_i
		puts cloptions[:clock]
		puts 'hi'
	else
		sleep 120
	end
end
