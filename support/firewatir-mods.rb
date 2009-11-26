require 'firewatir'

class Element
  # Returns true if the current elements returns true
  # Feature missing from FireWatir
  def visible?
    js = "(function(el) {
      var w = getWindows()[0].content;
      while(el && el != w.document) {
        w.console.log(el);
        var s = w.getComputedStyle(el, null);
        w.console.log(s);
        if(s.getPropertyValue('display') == 'none' || s.getPropertyValue('visibility') == 'hidden') return false;
        el = el.parentNode;
      }; 
      return true;
    })(#{element_object});"
    return js_eval(js) == 'true'
  end
end