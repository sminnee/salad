Given /cancel pop(?:-|\s)?ups/i do
  script = "window.confirm=window.alert=window.prompt=function(){ return false; };"
	@salad.evaluate_script(@salad.browser, script)
end

Given /confirm pop(?:-|\s)?ups/i do
  script ="window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return false; }";
	@salad.evaluate_script(@salad.browser, script)
end

Given /put "(.*)" in the pop(?:-|\s)?up/i do | value |
  script = "window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return \"#{value}\"; }"
	@salad.evaluate_script(@salad.browser, script)
end
