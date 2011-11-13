require 'rspec'
require File.dirname(__FILE__) + '/../lib/salad'

require "rubygems"
require "watir-webdriver"

$kill = nil
 
$browserName = 'firefox' unless $browserName
case $browserName.downcase
when /firefox/
    $browser = Watir::Browser.new :firefox
    $kill = 'firefox'

when /chrome/
    $browser = Watir::Browser.new :chrome
    $kill = 'chrome'

when /ie/
  require 'watir'
  $kill = 'ie'
  $browser = Watir::Browser.new :ie

else
  raise "Bad browser '#{$browserName}'.  Please use 'firefox', 'ie', or 'chrome'.  Safari support has been dropped."
end

# Set up 

if $baseURL then
  if not $baseURL.match(/\/$/) then
      $baseURL += '/'
  end
else
  $baseURL = "http://demo.silverstripe.com/"
end

$salad = Salad::Salad.new($browser, $baseURL)
$salad.setDebug($OPT_DEBUG)

# Make it go fast - IE only
# $browser.speed = :zippy

# Before each scenario, load in the globals
Before do
  @browser = $browser
  @baseURL = $baseURL
  @salad = $salad
  step "I visit /dev/tests/emptydb"
  @salad.resetContainer()
end

at_exit do
  # OPT_NOKILL avoids closing browser, for debugging
  if not $OPT_NOKIL then
    $browser.close
  end
end
