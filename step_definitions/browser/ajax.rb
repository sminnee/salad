=begin
Ajax Handling
This pair of methods lets us wait for ajax actions to complete before proceeding.

To use:
 * Call ajax_before_action prior to the action - e.g. button/link click
 * Call ajax_after_action after the action

What happens:
 * If the action didn't trigger an ajax call, then it won't wait
 * If the action did trigger an ajax call, then it will wait until after the success handler is
   completed

Because the handler does nothing if there wasn't an ajax call, it's safe to be wrapped around all
button/link clicks.
=end

def ajax_before_action(browser)
  
  # Warning: don't use // comments in the JS, only /* */, because newlines are removed
  
  js = <<-eos
      window.__ajaxStatus = function() { return 'no ajax'; };

      if(typeof window.__ajaxPatch == 'undefined') {
        window.__ajaxPatch = 1;
      
        var patchedList = "";

        /* Monkey-patch Prototype */
        if(typeof window.Ajax!='undefined' && typeof window.Ajax.Request!='undefined') {
          window.Ajax.Request.prototype.initialize = function(url, options) {
            this.transport = window.Ajax.getTransport();

            var __activeTransport = this.transport;
            window.__ajaxStatus = function() {
              return (__activeTransport.readyState == 4) ? 'success' : 'waiting';
            };

            this.setOptions(options);
            this.request(url);
          };
          patchedList += " prototype";
        }

        /* Monkey-patch jQuery */
        if(typeof window.jQuery!='undefined') {
          var _orig_ajax = window.jQuery.ajax;

          window.jQuery(window).ajaxStop(function() {
            window.__ajaxStatus = function() { return 'success'; };
          });
        
          window.jQuery.ajax = function(s) {
            window.__ajaxStatus = function() { return 'waiting'; };
            _orig_ajax(s);
          };
          patchedList += " jquery";
        }
        return "patched" + patchedList;
      } else {
        return "already patched: " + window.__ajaxPatch;
      }
  eos

	@salad.evaluate_script(browser, js)
  
  #js = js.gsub(/[\n\r]/, "; ")
  #browser.js_eval(js)
  
  # For debugging
  #puts "Patching:"
  #puts browser.js_eval(js)
end

def ajax_after_action(browser)
  wait_until {
		status = @salad.evaluate_script_return(browser, "window.__ajaxStatus ? window.__ajaxStatus() : 'no ajax'")
    status != "waiting"
  }
end