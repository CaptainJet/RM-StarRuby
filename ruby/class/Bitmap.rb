class Bitmap
  
  attr_reader :rect
  attr_accessor :font, :texture
  
  def initialize(width, height = nil)
    if width.is_a?(String)
      @texture = StarRuby::Texture.load(width)
    else
      @texture = StarRuby::Texture.new(width, height)
    end
    @rect = Rect.new(0, 0, @texture.width, @texture.height)
  end
  
  def dispose
    @texture.dispose
  end
  
  def disposed?
    @texture.disposed?
  end
  
  def width
    @texture.width
  end
  
  def height
    @texture.height
  end
  
  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    ops = {:src_x => src_rect.x, :src_y => src_rect.y, :src_width => src_rect.width, :src_height => src_rect.height, :alpha => opacity}
    @texture.render_texture(src_bitmap.texture, x, y, ops)
  end
  
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    ops = {:src_x => src_rect.x, :src_y => src_rect.y, :src_width => src_rect.width, :src_height => src_rect.height, :alpha => opacity, :scale_x => dest_rect.width / src_rect.width.to_f, :scale_y => dest_rect.height / src_rect.height.to_f}
    @texture.render_texture(src_bitmap.texture, dest_rect.x, dest_rect.y, ops)
  end
  
  def fill_rect(*args)
    case args.size
    when 2, 5
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
        color = args[1]
      else
        x, y, width, height = *args[0..3]
        color = args[4]
      end
    else
      raise ArgumentError
    end
    @texture.fill_rect(x, y, width, height, color)
  end
  
  def gradient_fill_rect(*args)
  end
  
  def clear
    @texture.clear
  end
  
  def clear_rect(*args)
    case args.size
    when 1, 4
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
      else
        x, y, width, height = *args
      end
    else
      raise ArgumentError
    end
    fill_rect(x, y, width, height, Color.new(0, 0, 0, 0))
  end
  
  def get_pixel(x, y)
    color = @texture[x, y]
    Color.new(color.red, color.green, color.blue, color.alpha)
  end
  
  def set_pixel(x, y, color)
    @texture[x, y] = color
  end
  
  def hue_change(hue)
    @texture.change_hue!(hue)
  end
  
  def blur
  end
  
  def radial_blur(angle, division)
  end
  
  def draw_text(*args)
    case args.size
    when 2, 3
      x, y, width, height = *args[0].to_a
      string = args[1]
      align = args[2]
    when 5, 6
      x, y, width, height = *args[0, 4]
      string = args[4]
      align = args[5]
    else
      raise ArgumentError
    end
    star_font = @font.star_font
    if @font.outline
      @font.size += 2
      @texture.render_text(string, x, y, @font.star_font, @font.out_color, false)
      @font.size -= 2
    end
    if @font.shadow
      @texture.render_text(x + 2, y + 2, star_font, Color.new(0, 0, 0, 255), false)
    end
    @texture.render_text(x, y, star_font, @font.color, false)
  end
    
  def text_size(string)
    size = @font.star_font.get_size(string)
    Rect.new(0, 0, size[0], size[1])
  end
end