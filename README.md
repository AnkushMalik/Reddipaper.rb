# Reddipaper.rb

Ruby Script for Automagically setting the top trending images from reddit as your desktop wallpaper 

![wp](https://i.imgur.com/33EbYWP.png)


### Usage:
```
ruby reddipaper.rb
```

#### What it does?
##### Default Behavior

* It would collect the top 20 rated wallpapers from `/r/Wallpaper` 
* Selects only the high resolutions images one by one and sets them as your desktop wallpaper (For a duration of 45secs)
* Keep looping until you kill the script :)


#### Customizations:

To select  wallpapers from `r/Wallpapers` subreddit, and set duration for `45` seconds

```bash
$ redditwallpapers -t Wallpapers -c 45
```
## Requirements
* Linux (Gnome shell or Unity)
* Ruby
* Nokogiri Gem
