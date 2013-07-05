class Window
  
  attr_reader :windowskin, :contents, :opacity, :back_opacity, :contents_opacity, :created_index
  attr_reader :width, :height, :cursor_rect, :padding
  attr_accessor :x, :y, :z, :ox, :oy, :active, :visible, :pause, :viewport, :openness, :arrows_visible, :tone, :padding_bottom
  
  def initialize(viewport = nil)
    @created_index = Graphics.created_increment
    Graphics.created_increment += 1
    @viewport = viewport
    @x, @y, @z, @ox, @oy = 0, 0, 100, 0, 0
    @active = false
    @visible = true
    @pause = false
    @opacity = 255
    @back_opacity = 192
    @contents_opacity = 255
    @openness = 255
    @arrows_visible = true
    @padding = 12
    @padding_bottom = 12
    @sprites = {
      :contents => Sprite.new,
      :back => Sprite.new,
      :back_overlay => Sprite.new,
      :border => Sprite.new,
      :arrow_left => Sprite.new,
      :arrow_up => Sprite.new,
      :arrow_right => Sprite.new,
      :arrow_down => Sprite.new,
      :pause_one => Sprite.new,
      :pause_two => Sprite.new,
      :pause_three => Sprite.new,
      :pause_four => Sprite.new,
      :cursor => Sprite.new
    }
    @cursor_ticks = 0
    @pause_ticks = 0
    @sprites.values.each do |a|
      Graphics.remove_sprite(a); a.bitmap = Bitmap.new(1, 1)
    end
    Graphics.add_sprite(self)
  end
  
  def update
    if @active
      @cursor_ticks += 1
      if @cursor_ticks % 30 < 15
        @sprites[:cursor].opacity = 128 + 128 * (@cursor_ticks % 15) / 15.0
      else
        @sprites[:cursor].opacity = 255 - 128 * (@cursor_ticks % 15) / 15.0
      end
      @cursor_ticks = 0 if @cursor_ticks == 30
    end
    if @pause
      @pause_ticks += 1
      @pause_index = [:pause_one, :pause_two, :pause_three, :pause_four][(@pause_ticks / 15) % 4]
      @pause_ticks = 0 if @pause_ticks == 60
    end
  end
  
  def open?
    @openness == 255
  end
  
  def close?
    @openness == 0
  end
  
  def move(x, y, width, height)
    @x = x
    @y = y
    @width = width
    self.height = height
  end
  
  def windowskin=(bit)
    @windowskin = bit
    private_refresh if bit != nil
  end
  
  def padding=(int)
    @padding = int
    @padding_bottom = int
  end
  
  def contents=(bit)
    @contents = bit
    @sprites[:contents].bitmap = bit
  end
  
  def opacity=(int)
    @opacity = int
    @sprites.values.each do |a|
      a.opacity = int
    end
    @sprites[:back_opacity].opacity = @back_opacity
    @sprites[:contents].opacity = @contents_opacity
    @sprites[:cursor].opacity = 255
  end
  
  def back_opacity=(int)
    @back_opacity = int
    @sprites[:back].opacity = int
  end
  
  def contents_opacity=(int)
    @contents_opacity = int
    @sprites[:contents].opacity = int
  end
  
  def cursor_rect=(rect)
    @cursor_rect = rect
    setup_cursor
  end
  
  def width=(int)
    @width = int
    setup_background
    setup_background_overlay
    setup_border
  end
  
  def height=(int)
    @height = int
    setup_background
    setup_background_overlay
    setup_border
  end
  
  private
  
  def private_refresh
    setup_background
    setup_background_overlay
    setup_arrows
    setup_pauses
    setup_border
    setup_cursor
  end
  
  def setup_background
    @sprites[:back].bitmap.dispose
    @sprites[:back].dispose
    @sprites[:back] = Sprite.new
    Graphics.remove_sprite(@sprites[:back])
    bitm = Bitmap.new(128, 128)
    @sprites[:back].bitmap = bitm
    bitm.stretch_blt(Rect.new(0, 0, @width, @height), @windowskin, Rect.new(0, 0, 64, 64))
  end
  
  def setup_background_overlay
    @sprites[:back_overlay].bitmap.dispose
    @sprites[:back_overlay].dispose
    @sprites[:back_overlay] = Sprite.new
    Graphics.remove_sprite(@sprites[:back_overlay])
    bitm = Bitmap.new(@width, @height)
    @sprites[:back_overlay].bitmap = bitm
    src_rect = Rect.new(0, 64, 64, 64)
    sx = 0
    until sx >= @width
      sy = 0
      until sy >= @height
        @sprites[:back_overlay].bitmap.blt(sx, sy, @windowskin, src_rect)
        sy += 128
      end
      sx += 128
    end
  end
  
  def setup_arrows
    [:arrow_up, :arrow_down, :arrow_left, :arrow_right].each do |a|
      @sprites[a].bitmap.dispose
      @sprites[a].bitmap = Bitmap.new(16, 16)
    end
    @sprites[:arrow_up].blt(0, 0, @windowskin, Rect.new(80 + 8, 16, 16, 8))
    @sprites[:arrow_down].blt(0, 0, @windowskin, Rect.new(80 + 8, 16 + 16 + 8, 16, 8))
    @sprites[:arrow_left].blt(0, 0, @windowskin, Rect.new(80, 16 + 8, 8, 16))
    @sprites[:arrow_right].blt(0, 0, @windowskin, Rect.new(80 + 16 + 8, 16 + 8, 8, 16))
  end
  
  def setup_pauses
    [:pause_one, :pause_two, :pause_three, :pause_four].each do |a|
      @sprites[a].bitmap.dispose
      @sprites[a].bitmap = Bitmap.new(16, 16)
    end
    @sprites[:pause_one].blt(0, 0, @windowskin, Rect.new(96, 64, 16, 16))
    @sprites[:pause_two].blt(0, 0, @windowskin, Rect.new(96 + 16, 64, 16, 16))
    @sprites[:pause_three].blt(0, 0, @windowskin, Rect.new(96, 80, 16, 16))
    @sprites[:pause_four].blt(0, 0, @windowskin, Rect.new(96 + 16, 80, 16, 16))
  end
  
  def setup_border
  end
  
  def setup_cursor
  end
end