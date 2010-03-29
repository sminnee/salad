Given /cancel pop-ups/i do
  script = "window.confirm=window.alert=window.prompt=function(){ return false; };"
	@salad.evaluate_script(script)
end

Given /confirm pop-ups/i do
  script ="window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return false; }";
	@salad.evaluate_script(script)
end

Given /put "(.*)" in the pop-up/i do | value |
  script = "window.confirm=window.alert=function(){ return true; }; window.prompt=function(){ return \"#{value}\"; }"
	@salad.evaluate_script(script)
end
