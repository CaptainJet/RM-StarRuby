module Graphics

  class << self
    
    attr_reader :frame_rate, :brightness
    attr_accessor :frame_count, :starruby
    
    def frame_rate=(int)
      @frame_rate = [[120, int].min, 10].max
      @starruby.fps = @frame_rate
    end
    
    def brightness=(int)
      @brightness = [[255, int].min, 0].max
    end
  end

  @@sprites = []
  
  module_function
  
  def _reset
    @frame_count = 0
    @@sprites.each {|a| a.bitmap.dispose; a.dispose }
    @@sprites.clear
  end
  
  def update
    #draw
    if @starruby.window_closing?
      @starruby.dispose
      exit
      return
    end
    @starruby.update_screen
    @frame_count += 1
    @starruby.wait
  end
  
  def wait(duration)
    duration.times { update }
  end
  
  def fadeout(duration)
    rate = @brightness / duration.to_f
    until @brightness <= 0
      @brightness -= rate
      update
    end
    @brightness = 0
  end
  
  def fadein(duration)
    rate = 255 / duration.to_f
    until @brightness >= 255
      @brightness += rate
      update
    end
    @brightness = 255
  end
  
  def freeze
    @frozen = true
  end
  
  def transition(duration = 10, filename = nil, vague = 40)
    @frozen = false
  end
  
  def snap_to_bitmap
    f = Bitmap.new(1, 1)
    f.texture = @starruby.screen.dup
    f
  end
  
  def frame_reset
  end
  
  def width
    @starruby.width
  end
  
  def height
    @starruby.height
  end
  
  def resize_screen(width, height)
    full = @starruby.fullscreen?
    @starruby.dispose
    f = StarRuby::Game.new(width, height, :cursor => StarRuby::CONFIG[:Cursor])
    f.fps =  @frame_rate
    f.fullscreen = full
    f.title = StarRuby::CONFIG[:Title]
    @starruby = f
  end
  
  def play_movie(filename)
  end
  
  # NEW
  
  def set_fullscreen(bool)
    @starruby.fullscreen = bool
  end
  
  def add_sprite(sprite)
    @@sprites << sprite
    resort_sprite_z
  end
  
  def remove_sprite(sprite)
    @@sprites.delete(sprite)
  end
  
  def resort_sprite_z
    @@sprites.sort! do |a, b|
      if !a.viewport.nil?
        if !b.viewport.nil?
          if a.viewport.z == b.viewport.z
            a.z <=> b.z
          else
            a.viewport.z <=> b.viewport.z
          end
        else
          a.viewport.z <=> b.z
        end
      elsif !b.viewport.nil?
        a.z <=> b.viewport.z
      else
        a.z <=> b.z
      end
    end
  end
end