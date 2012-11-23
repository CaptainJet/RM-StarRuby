module Input

  DOWN = [:down]
  UP = [:up]
  LEFT = [:left]
  RIGHT = [:right]
  A = [:lshiftkey, :rshiftkey]
  B = [:x, :escape, :d0, :numpad0]
  C = [:enter, :space, :z]
  X = [:a]
  Y = [:s]
  Z = [:d]
  L = [:q]
  R = [:w]
  SHIFT = [:lshiftkey, :rshiftkey]
  CTRL = [:lcontrolkey, :rcontrolkey]
  ALT = [:lmenu, :rmenu]
  F5 = [:f5]
  F6 = [:f6]
  F7 = [:f7]
  F8 = [:f8]
  F9 = [:f9]

  module_function
  
  def update
    Graphics.starruby.update_state
    @old_keys = @current_keys || []
    @current_keys = StarRuby::Input.keys(:keyboard)
    @repeat_keys = StarRuby::Input.keys(:keyboard, :delay => 5, :duration => 1, :interval => 5)
  end
  
  def trigger?(key)
    self.const_get(key).each {|a|
      return true if @current_keys.include?(a) && !@old_keys.include?(a)
    }
    return false
  end
  
  def press?(key)
    self.const_get(key).each {|a|
      return true if @current_keys.include?(a)
    }
    return false
  end
  
  def repeat?(key)
    self.const_get(key).each {|a|
      return true if @repeat_keys.include?(a)
    }
    return false
  end
  
  def dir4
    return 2 if press?(:DOWN)
    return 4 if press?(:LEFT)
    return 6 if press?(:RIGHT)
    return 8 if press?(:UP)
    return 0
  end
  
  def dir8
    return 1 if press?(:DOWN) && press?(:LEFT)
    return 3 if press?(:DOWN) && press?(:RIGHT)
    return 7 if press?(:UP) && press?(:LEFT)
    return 9 if press?(:UP) && press?(:RIGHT)
    return dir4
  end
end