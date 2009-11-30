Given /cancel pop-ups/i do
  @browser.evaluate_script("window.confirm=window.alert=window.prompt=function(){ return false; };")
end

Given /confirm pop-ups/i do
  @browser.evaluate_script("window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return false; }")
end

Given /put "(.*)" in the pop-up/i do | value |
  @browser.evaluate_script("window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return \"#{value}\"; }")
end
