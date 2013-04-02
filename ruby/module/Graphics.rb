module Graphics

  class << self
    
    attr_reader :frame_rate, :brightness
    attr_accessor :frame_count, :starruby, :created_increment
    
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
    @created_increment = 0
    @@sprites.each do |a| 
      a.bitmap.dispose
      a.dispose
    end
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
    duration.times do
      update
    end
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
      if (a.is_a?(Viewport) ? a.z : a.viewport ? a.viewport.z : a.z) == (b.is_a?(Viewport) ? b.z : b.viewport ? b.viewport.z : b.z)
        if a.is_a?(Sprite) && b.is_a?(Sprite)
          if a.z == b.z
            if a.y == b.y && a.viewport == b.viewport
              a.created_increment <=> b.created_increment
            elsif a.viewport == b.viewport
              a.y <=> b.y
            else
              a.created_increment <=> b.created_increment
            end
          else
            a.z <=> b.z
          end
        else
          a.created_increment <=> b.created_increment
        end
      else
        (a.is_a?(Viewport) ? a.z : a.viewport ? a.viewport.z : a.z) <=> (b.is_a?(Viewport) ? b.z : b.viewport ? b.viewport.z : b.z)
      end
    end
  end
end