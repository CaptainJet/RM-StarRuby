class Object
  
  def rgss_main(&block)
    loop { 
      begin
        block.call
      rescue RGSSReset
        Graphics._reset
        retry
      end
    }
  end
  
  def rgss_stop
    loop { Graphics.update }
  end
  
  def load_data(filename)
    File.open(filename, "rb") { |f|
      obj = Marshal.load(f)
    }
  end
  
  def save_data(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end
  
  def msgbox(*args)
    return nil
  end
  
  def msgbox_p(*args)
    return nil
  end
end