class Font
  
  class << self
    
    attr_accessor :default_name, :default_size, :default_bold
    attr_accessor :default_italic, :default_shadow, :default_outline
    attr_accessor :default_color, :default_out_color
    
    def exist?(name)
      StarRuby::Font.exist?(name)
    end
  end
  
  self.default_name = ["Verdana", "Arial", "Courier New"]
  self.default_size = 24
  self.default_bold = false
  self.default_italic = false
  self.default_shadow = false
  self.default_outline = true
  self.default_color = Color.new(255, 255, 255, 255)
  self.default_out_color = Color.new(0, 0, 0, 128)
  
  attr_accessor :name, :size, :bold, :italic, :shadow, :outline, :color, :out_color
  
  def initialize(name = Font.default_name, size = Font.default_size)
    @name = name.dup
    @size = size
    @bold = Font.default_bold
    @italic = Font.default_italic
    @shadow = Font.default_shadow
    @outline = Font.default_outline
    @color = Font.default_color.dup
    @out_color = Font.default_out_color.dup
  end
  
  # NEW
  
  def first_existant_name
    if @name.is_a?(Array)
      @name.each do |a| 
        return a if Font.exist?(a)
      end
    else
      return @name if Font.exist?(@name)
    end
    return "Verdana"
  end
  
  def star_font
    StarRuby::Font.new(first_existant_name, @size, :bold => @bold, :italic =>@italic)
  end
end