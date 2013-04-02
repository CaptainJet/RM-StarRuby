class Plane
  
  attr_reader :created_index, :viewport, :z, :opacity, :color, :bitmap, :ox, :oy, :zoom_x, :zoom_y
  attr_accessor :blend_type, :tone, :visible
  
  def initialize(viewport = nil)
    @created_index = Graphics.created_increment
    Graphics.created_increment += 1
    @visible = true
    @z = 0
    @ox, @oy = 0, 0
    @zoom_x, @zoom_y = 1.0, 1.0
    @opacity = 255
    @blend_type = 0
    @viewport = viewport
    refresh_texture
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
  
  def zoom_x=(zoom_x)
    @zoom_x = zoom_x
    refresh_texture
  end
  
  def zoom_y=(zoom_y)
    @zoom_y = zoom_y
    refresh_texture
  end
  
  private
  
  def refresh_texture
    if @bitmap.nil?
      @texture = StarRuby::Texture.new(viewport ? viewport.rect.width : Graphics.width, viewport ? viewport.rect.height : Graphics.height)
      return
    end
    wx = @bitmap.width * @zoom_x
    wy = @bitmap.height * @zoom_y
    sx = @ox
    sy = @oy
    @texture = StarRuby::Texture.new(viewport ? viewport.rect.width : Graphics.width, viewport ? viewport.rect.height : Graphics.height)
    until sx >= @texture.width
      until sy >= @texture.height
        @texture.render_texture(@bitmap.texture, sx, sy, :scale_x => @zoom_x, :scale_y => @zoom_y)
        sy += wy
      end
      sx += wx
    end
    @texture.render_rect(0, 0, @texture.width, @texture.height, StarRuby::Color.new(*@color.to_a.collect {|a| a.round })) if @color
  end