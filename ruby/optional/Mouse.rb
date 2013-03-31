module Mouse
  
  module_function
  
  def click?(button)
    return true if @keys.include?(button)
    return false
  end
  
  def press?(button)
    return true if @press.include?(button)
    return false
  end
  
  def set_pos(x_pos = 0, y_pos = 0)
    Input.mouse_location = [x_pos, y_pos]
  end
  
  def moved?
    @pos != @old_pos
  end
  
  def set_cursor(image)
    (@cursor ||= Sprite_Cursor.new).set_cursor(image)
  end
  
  def revert_cursor
    (@cursor ||= Sprite_Cursor.new).revert
  end
  
  def update
    if !@init
      @keys = []
      @press = []
      @pos = Mouse.pos
      @cursor = Sprite_Cursor.new
      @init = true
    end
    if !$game_switches.nil? 
      if $game_switches[Jet::MouseSystem::TURN_MOUSE_OFF_SWITCH]
        @keys, @press = [], []
        @pos = [-1, -1]
        @cursor.update
        return
      end
    end
    @old_pos = @pos.dup
    @pos = Mouse.pos
    @keys.clear
    @press.clear
    @old_keys = @current_keys || []
    @current_keys = StarRuby::Input.keys(:mouse)
    @keys.push(1) if @current_keys.include?(:left) && !@old_keys.include?(:left)
    @keys.push(2) if @current_keys.include?(:right) && !@old_keys.include?(:right)
    @keys.push(3) if @current_keys.include?(:middle) && !@old_keys.include?(:middle)
    @press.push(1) if @current_keys.include?(:left)
    @press.push(2) if @current_keys.include?(:right)
    @press.push(3) if @current_keys.include?(:middle)
    @cursor.update rescue @cursor = Sprite_Cursor.new
  end
    
  def pos
    Input.mouse_location
  end
    
  def grid
    [(@pos[0]/32),(@pos[1]/32)]
  end
  
  def true_grid
    [grid[0] + $game_map.display_x, grid[1] + $game_map.display_y]
  end
  
  def grid_by_pos
    asd = pos
    [pos[0] / 32, pos[1] / 32]
  end
  
  def true_grid_by_pos
    [grid_by_pos[0] + $game_map.display_x, grid_by_pos[1] + $game_map.display_y]
  end
  
  def area?(x, y, width, height)
    @pos[0].between?(x, width + x) && @pos[1].between?(y, height + y)
  end
  
  class Sprite_Cursor < Sprite
    
    def initialize
      super(nil)
      self.z = 50000
      @bitmap_cache = initial_bitmap
      if Jet::MouseSystem::DEV_OUTLINE
        @outline = Sprite.new(nil)
        @outline.bitmap = Bitmap.new(32, 32)
        @outline.bitmap.fill_rect(0, 0, 32, 32, Color.new(0, 0, 0, 190))
        @outline.bitmap.fill_rect(1, 1, 30, 30, Color.new(0, 0, 0, 0))
      end
    end
    
    def initial_bitmap
      begin
        self.bitmap = Cache.picture(Jet::MouseSystem::CURSOR_IMAGE)
      rescue
        self.bitmap = Bitmap.new(24, 24)
        icon_index = Jet::MouseSystem::CURSOR_ICON
        rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
        self.bitmap.blt(0, 0, Cache.system("Iconset"), rect, 255)
      end
      self.bitmap.dup
    end
    
    def set_cursor(image)
      if image.is_a?(Integer)
        self.bitmap = Bitmap.new(24, 24)
        icon_index = image
        rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
        self.bitmap.blt(0, 0, Cache.system("Iconset"), rect, 255)
      else
        self.bitmap = Cache.picture(image)
      end
    end
    
    def revert
      self.bitmap = @bitmap_cache.dup
    end
    
    def update
      super
      self.x, self.y = *Mouse.pos
      self.visible = !$game_switches[Jet::MouseSystem::TURN_MOUSE_OFF_SWITCH]
      if !@outline.nil?
        @outline.visible = SceneManager.scene_is?(Scene_Map)
        @outline.x = Mouse.grid[0] * 32
        @outline.y = [Mouse.grid[1] * 32, 1].max
      end
    end
  end
end