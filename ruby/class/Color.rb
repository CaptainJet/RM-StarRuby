class Color
  
  attr_reader :red, :green, :blue, :alpha, :starruby_color
  
  def initialize(*args)
    case args.size
    when 0
      set(0, 0, 0, 0)
    when 3
      args << 255
      set(*args)
    when 4
      set(*args)
    else
      raise ArgumentError
    end
  end
  
  def set(*args)
    case args.size
    when 1
      if args[0].is_a?(Color)
        re = args[0]
        set(*args[0].to_a)
      else
        raise ArgumentError
      end
    when 3
      args << 255
      set(*args)
    when 4
      self.red = args[0]
      self.green = args[1]
      self.blue = args[2]
      self.alpha = args[3]
    else
      raise ArgumentError
    end
  end
  
  def empty
    set(0, 0, 0, 0)
  end
  
  def red=(int)
    @red = [[255, int].min, 0].max.to_f
  end
  
  def green=(int)
    @green = [[255, int].min, 0].max.to_f
  end
  
  def blue=(int)
    @blue = [[255, int].min, 0].max.to_f
  end
  
  def alpha=(int)
    @alpha = [[255, int].min, 0].max.to_f
  end
  
  def to_a
    [red, green, blue, alpha]
  end
  
  def starruby_color
    @old_struct ||= Struct.new(:red, :green, :blue, :alpha, :color).new(0, 0, 0, 0, 0)
    if @old_struct.red != self.red || @old_struct.green != self.green || @old_struct.blue != self.blue || @old_struct.alpha != self.alpha
      @old_struct.red = self.red
      @old_struct.green = self.green
      @old_struct.blue = self.blue
      @old_struct.alpha = self.alpha
      @old_struct.color = StarRuby::Color.new(*self.to_a.collect {|a| a.round })
    end
    @old_struct.color
  end
  
  def _dump(d = 0)
    [@red, @green, @blue, @alpha].pack('d4')
  end
   
  def self._load(s)
    Color.new(*s.unpack('d4'))
  end
end