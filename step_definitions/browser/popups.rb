Given /cancel pop-ups/i do
  @browser.js_eval("var w=getWindows()[0].content; w.confirm=w.alert=w.prompt=function(){ return false; };")
end

Given /confirm pop-ups/i do
  @browser.js_eval("var w=getWindows()[0].content; w.confirm=w.alert=function(){ return true; }; w.prompt=function(){ return false; }")
end

Given /put "(.*)" in the pop-up/i do
  @browser.js_eval("var w=getWindows()[0].content; w.confirm=w.alert=function(){ return true; }; w.prompt=function(){ return false; }")
end
