class Sprite
  
  attr_reader :opacity, :bush_opacity, :z, :viewport, :created_index, :src_rect, :texture
  attr_accessor :x, :y, :ox, :oy, :zoom_x, :zoom_y
  attr_accessor :bitmap, :visible
  attr_accessor :wave_amp, :wave_length, :wave_speed, :wave_phase
  attr_accessor :angle, :mirror, :color, :tone, :blend_type
  attr_accessor :bush_depth
  
  BLEND = {0 => :alpha, 1 => :add, 2 => :sub}
  
  def initialize(viewport = nil)
    @created_index = Graphics.created_increment
    Graphics.created_increment += 1
    @viewport = viewport
    @visible = true
    @x, @y, @z = 0, 0, 0
    @ox, @oy = 0, 0
    @zoom_x, @zoom_y = 1.0, 1.0
    @angle = 0
    @mirror = false
    @bush_depth = 0
    @bush_opacity = 128
    @opacity = 255
    @blend_type = 0
    @wave_speed = 360
    @src_rect = Rect.new
    Graphics.add_sprite(self)
    refresh_texture
  end
  
  def initialize_copy
    f = super
    Graphics.add_sprite(f)
    f
  end
  
  def dispose
    @disposed = true
    Graphics.remove_sprite(self)
  end
  
  def disposed?
    @disposed
  end
  
  def flash(color, duration)
    @flash_color = color || Color.new(0, 0, 0, 0)
    @flash_duration = duration
  end
  
  def update
    @flash_duration = [@flash_duration - 1, 0].max
    @flash_color = nil if @flash_duration == 0
    #wave phase stuff here
  end
  
  def width
    @src_rect.width
  end
  
  def height
    @src_rect.height
  end
  
  def opacity=(int)
    @opacity = [[int, 255].min, 0].max
  end
  
  def bush_opacity=(int)
    @bush_opacity = [[int, 255].min, 0].max
  end
  
  def bitmap=(bitmap)
    @bitmap = bitmap
    @src_rect = Rect.new(0, 0, bitmap.width, bitmap.height)
  end
  
  def viewport=(viewport)
    @viewport = viewport
    Graphics.resort_sprite_z
  end
  
  def src_rect=(src_rect)
    @src_rect = src_rect
    refresh_texture
  end
  
  def z=(z)
    @z = z
    Graphics.resort_sprite_z
  end
  
  private
  
  def refresh_texture
    if @bitmap.nil?
      @texture = StarRuby::Texture.new(@src_rect.width, @src_rect.height)
      return
    end
    @texture = @bitmap.texture.dup
    @texture.render_rect(0, 0, @texture.width, @texture.height, @color.starruby_color) if @color
  end
end