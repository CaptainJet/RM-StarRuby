class Object
  
  def rgss_main(&block)
    begin
      block.call
    rescue RGSSReset
      Graphics._reset
      retry
    end
  end
  
  def rgss_stop
    loop do 
      Graphics.update
    end
  end
  
  def load_data(filename)
    File.open(filename, "rb") do |f|
      obj = Marshal.load(f)
    end
  end
  
  def save_data(obj, filename)
    File.open(filename, "wb") do |f|
      Marshal.dump(obj, f)
    end
  end
  
  def msgbox(*args)
    return nil
  end
  
  def msgbox_p(*args)
    return nil
  end
end