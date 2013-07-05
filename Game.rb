Dir["./so/**/*.so"].each do |a|
  require a
end
Dir["./ruby/**/*.rb"].each do |a|
  require a
end

module StarRuby
  
  CONFIG = {
    :RTP => "RPGVXAce",
    :Title => "Game",
    :Width => 544,
    :Height => 416,
    :Fullscreen => false,
    :Framerate => 60,
    :Cursor => true
  }
  
  File.open('Game.ini', 'r') do |inFile|
    inFile.each_line do |line|
      if line[/(.*)=(\d+)/i]
        CONFIG[$1.to_sym] = $2.to_i
      elsif line[/(.*)=(true|false)/i]
        CONFIG[$1.to_sym] = $2.downcase == "true"
      elsif line[/(.*)=(.*)/i]
        CONFIG[$1.to_sym] = $2
      end
    end
  end
end

f = StarRuby::Game.new(StarRuby::CONFIG[:Width], StarRuby::CONFIG[:Height], :cursor => StarRuby::CONFIG[:Cursor])
f.fps =  StarRuby::CONFIG[:Framerate]
f.fullscreen = StarRuby::CONFIG[:Fullscreen]
f.title = StarRuby::CONFIG[:Title]
Graphics.starruby = f
Graphics._reset

$RGSS_SCRIPTS = load_data("Data/Scripts.rvdata2")
#~ $RGSS_SCRIPTS.each {|a|
  #~ eval(Zlib::Inflate.inflate(a[2]))
#~ }
rgss_main { loop { Input.update; Graphics.update } }