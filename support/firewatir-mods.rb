require 'firewatir'

class Element
  # Returns true if the current elements returns true
  # Feature missing from FireWatir
  def visible?
    js = "(function(el) {
      var w = getWindows()[#{$browser.window_index}].content;
      while(el && el != w.document) {
        var s = w.getComputedStyle(el, null);
        if(s.getPropertyValue('display') == 'none' || s.getPropertyValue('visibility') == 'hidden') return false;
        el = el.parentNode;
      }; 
      return true;
    })(#{element_object});"
    return js_eval(js) == 'true'
  end
end

class FireWatir::Firefox
  
  def resetContainer()
    jssh_command =  "var #{window_var} = getWindows()[#{@window_index}];"
    jssh_command << "var #{browser_var} = #{window_var}.getBrowser();"
    jssh_command << "var #{document_var} = #{browser_var}.contentDocument;"
    jssh_command << "var #{body_var} = #{document_var}.body;"
    jssh_command.gsub!(/\n/, "")
    js_eval jssh_command

    @window_title = js_eval "#{document_var}.title"
    @window_url = js_eval "#{document_var}.URL"
  end

  def evaluate_script(script)
    # Warning: don't use // comments in the JS, only /* */, because newlines are removed
  
    outerScript = <<-eos
    (function(window) {
      #{script};
    })(getWindows()[#{@window_index}].content);
    eos
    
    return self.js_eval(outerScript)
  end

  def evaluate_script_alternate(script)
    # Warning: don't use // comments in the JS, only /* */, because newlines are removed
  
    outerScript = <<-eos
    var _old_window = window;
    var window = getWindows()[#{@window_index}].content;
    #{script};
    window = _old_window;
    delete _old_window;
    eos
    
    return self.js_eval(outerScript)
  end

end