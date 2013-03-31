class StarRuby::Color
  
  def int8_mult(a, b)
    t = a * b + 0x80
    ((t >> 8) + t) >> 8
  end
  
  def interpolate(bg, alpha)
    return self if alpha >= 255 || bg.nil?
    return bg if alpha <= 0
    alpha_com = 255 - alpha
    new_r = int8_mult(alpha, self.red) + int8_mult(alpha_com, bg.red)
    new_g = int8_mult(alpha, self.green) + int8_mult(alpha_com, bg.green)
    new_b = int8_mult(alpha, self.blue) + int8_mult(alpha_com, bg.blue)
    new_a = int8_mult(alpha, self.alpha) + int8_mult(alpha_com, bg.alpha)
    StarRuby::Color.new(new_r, new_g, new_b, new_a)
  end
end