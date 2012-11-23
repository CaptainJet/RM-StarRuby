module Audio

  module_function
  
  def setup_midi
  end
  
  def bgm_play(filename, volume = 100, pitch = 100, pos = 0)
    bgm_stop
    StarRuby::Audio.play_bgm(filename, :loop => true, :volume => volume, :position => pos)
  end
  
  def bgm_stop
    StarRuby::Audio.stop_bgm
  end
  
  def bgm_fade(time)
    StarRuby::Audio.stop_bgm(:time => time)
  end
  
  def bgm_pos
    StarRuby::Audio.bgm_position
  end
  
  def bgs_play(filename, volume = 100, pitch = 100, pos = 0)
  end
  
  def bgs_stop
  end
  
  def bgs_fade(time)
  end
  
  def bgs_pos
  end
  
  def me_play(filename, volume = 100, pitch = 100)
  end
  
  def me_stop
  end
  
  def me_fade(time)
  end
  
  def se_play(filename, volume = 100, pitch = 100)
    StarRuby::Audio.play_se(filename, :volume => volume)
  end
  
  def se_stop
    StarRuby::Audio.stop_all_ses
  end
end