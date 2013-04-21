class Plane
  
  attr_reader :created_index, :viewport, :z, :opacity, :color, :bitmap, :ox, :oy
  attr_accessor :blend_type, :tone, :visible, :zoom_x, :zoom_y
  
  def initialize(viewport = nil)
    @created_index = Graphics.created_increment
    Graphics.created_increment += 1
    Graphics.add_sprite(self)
    @visible = true
    @z = 0
    @ox, @oy = 0, 0
    @zoom_x, @zoom_y = 1.0, 1.0
    @opacity = 255
    @blend_type = 0
    @viewport = viewport
    refresh_texture
  end
  
  def initialize_copy
    f = super
    Graphics.add_sprite(f)
    f
  end
  
  def dispose
    @texture.dispose
  end
  
  def disposed?
    @texture.disposed?
  end
  
  def viewport=(viewport)
    @viewport = viewport
    Graphics.resort_sprite_z
    refresh_texture
  end
  
  def z=(z)
    @z = z
    Graphics.resort_sprite_z
  end
  
  def opacity=(int)
    @opacity = [[int, 255].min, 0].max
  end
  
  def bitmap=(bitmap)
    @bitmap = bitmap
    refresh_texture
  end
  
  def color=(color)
    @color = color
    refresh_texture
  end
  
  def ox=(ox)
    @ox = ox
    refresh_texture
  end
  
  def oy=(oy)
    @oy = oy
    refresh_texture
  end
  
  private
  
  def refresh_texture
    if @bitmap.nil?
      @texture = StarRuby::Texture.new(viewport ? viewport.rect.width : Graphics.width, viewport ? viewport.rect.height : Graphics.height)
      return
    end
    wx = @bitmap.width
    wy = @bitmap.height
    sx = -@ox
    @texture = StarRuby::Texture.new(viewport ? viewport.rect.width : Graphics.width, viewport ? viewport.rect.height : Graphics.height)
    until sx >= @texture.width
      sy = -@oy
      until sy >= @texture.height
        @texture.render_texture(@bitmap.texture, sx, sy)
        sy += wy
      end
      sx += wx
    end
    @texture.render_rect(0, 0, @texture.width, @texture.height, @color.starruby_color) if @color
  end
end