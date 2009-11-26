require 'spec'

$killFF = false
 
if ENV['SAFARIWATIR']
  require 'safariwatir'
  Browser = Watir::Safari
else
  case RUBY_PLATFORM
  when /darwin/
    require 'firewatir'

    class FireWatir::Firefox
      # fixes the timeout caused by firefox taking ages to
      # load, preventing a connection from being made to JSSH
      # Note that this can't be placed in firewatir-mods
      def set_defaults(no_of_tries = 0)
        begin
          $jssh_socket = TCPSocket::new(MACHINE_IP, "9997")
          $jssh_socket.sync = true
          read_socket()
        rescue
          no_of_tries += 1
          sleep 0.1
          retry if no_of_tries < 300
          raise UnableToStartJSShException, "Unable to connect to machine : #{MACHINE_IP} on port 9997. Make sure that JSSh is properly installed and Firefox is running with '-jssh' option"
        end
        @error_checkers = []
      end
    end
    
    Watir::Browser.default = 'firefox'
    Browser = Watir::Browser
    $killFF = true
  when /win32|mingw/
    require 'watir'
    Browser = Watir::IE
  when /java/
    require 'celerity'
    Browser = Celerity::Browser
  else
    raise "This platform is not supported (#{PLATFORM})"
  end
end

# Set up 
$browser = Browser.new
$baseURL = 'http://localhost/airnz1/'

# Make it go fast - IE only
# $browser.speed = :zippy

# Reset database
$browser.goto $baseURL + 'dev/tests/startsession?fixture=sapphire/tests/Bare.yml&flush=1'

# Before each scenario, load in the globals
Before do
  @browser = $browser
  @baseURL = $baseURL
end
 
at_exit do
  # Let us see the aftermath for 10 seconds
  sleep 10
  
  # Kill database
  $browser.goto $baseURL + 'dev/tests/endsession'

  if $killFF then `killall -9 firefox-bin` end
end
