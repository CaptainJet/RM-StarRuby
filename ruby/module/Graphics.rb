module Graphics

  class << self
    
    attr_reader :frame_rate, :brightness
    attr_accessor :frame_count, :starruby
    
    def frame_rate=(int)
      @frame_rate = [[120, int].min, 10].max
    end
    
    def brightness=(int)
      @brightness = [[255, int].min, 0].max
    end
  end

  @@sprites = []
  
  module_function
  
  def update
    #draw
    self.starruby.update_screen
    self.framerate += 1
    self.starruby.wait
  end
  
  def wait(duration)
    duration.times { update }
  end
  
  def fadeout(duration)
    rate = @brightness / duration.to_f
    until @brightness <= 0
      self.brightness -= rate
      update
    end
    self.brightness = 0
  end
  
  def fadein(duration)
    rate = 255 / duration.to_f
    until @brightness >= 255
      self.brightness += rate
      update
    end
    self.brightness = 255
  end
  
  def freeze
    @frozen = true
  end
  
  def transition(duration = 10, filename = nil, vague = 40)
    @frozen = false
  end
  
  def snap_to_bitmap
    f = Bitmap.new(1, 1)
    f.texture = self.starruby.screen.dup
    f
  end
  
  def frame_reset
  end
  
  def width
    self.starruby.width
  end
  
  def height
    self.starruby.height
  end
  
  def resize_screen(width, height)
  end
  
  def play_movie(filename)
  end
  
  # NEW
  
  def add_sprite(sprite)
    @@sprites << sprite
  end
  
  def remove_sprite(sprite)
    @@sprites.delete(sprite)
  end
end