Dir["./so/**/*.so"].each {|a| require a }
Dir["./ruby/**/*.rb"].each {|a| require a }

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

if __FILE__ == $0
  StarRuby::Game.run(StarRuby::CONFIG[:Width], StarRuby::CONFIG[:Height], :cursor => StarRuby::CONFIG[:Cursor], :fps => StarRuby::CONFIG[:Framerate], :title => StarRuby::CONFIG[:Title], :fullscreen => StarRuby::CONFIG[:Fullscreen]) do |game|
    Graphics.starruby = game
    Graphics.frame_rate = StarRuby::CONFIG[:Framerate]
    Graphics.frame_count= 0
  end
end