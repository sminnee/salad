Given /cancel pop-ups/i do
  script = "window.confirm=window.alert=window.prompt=function(){ return false; };"

  # Special case for FireWatir
  if @browser.respond_to?('evaluate_script_alternate')
    @browser.evaluate_script_alternate(script)
  elsif @browser.respond_to?('execute_script')
    @browser.execute_script(script)
  else
    @browser.evaluate_script(script)
  end
end

Given /confirm pop-ups/i do
  script ="window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return false; }";

  # Special case for FireWatir
  if @browser.respond_to?('evaluate_script_alternate')
    @browser.evaluate_script_alternate(script)
  elsif @browser.respond_to?('execute_script')
    @browser.execute_script(script)
  else
    @browser.evaluate_script(script)
  end
end

Given /put "(.*)" in the pop-up/i do | value |
  script = "window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return \"#{value}\"; }"

  # Special case for FireWatir
  if @browser.respond_to?('evaluate_script_alternate')
    @browser.evaluate_script_alternate(script)
  elsif @browser.respond_to?('execute_script')
    @browser.execute_script(script)
  else
    @browser.evaluate_script(script)
  end
end
