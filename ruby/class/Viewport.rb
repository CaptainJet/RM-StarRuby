class Viewport
  
  attr_reader :z
  attr_accessor :color, :tone, :rect, :visible, :ox, :oy
  
  def initialize(*args)
    case args.size
    when 0
      @rect = Rect.new(0, 0, Graphics.width, Graphics.height)
    when 1
      if args[0].is_a?(Rect)
        @rect = args[0]
      else
        raise ArgumentError
      end
    when 4
      @rect = Rect.new(*args)
    else
      raise ArgumentError
    end
    @visible = true
    @z = 0
    @ox = 0
    @oy = 0
  end
  
  def dispose
    @disposed = true
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
  end
  
  def z=(z)
    @z = z
    Graphics.resort_sprite_z
  end
end