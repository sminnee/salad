require 'spec'

$killFF = false
 
if $browserName and $browserName.downcase == 'safari'
  require 'safariwatir'
  Browser = Watir::Safari
else
  case RUBY_PLATFORM
  when /darwin/
    require 'firewatir'

    class FireWatir::Firefox
      # Modified implementation of Firewatir start-up to give it up to 30 seconds to get things sorted
      def initialize(options = {})
        if(options.kind_of?(Integer))
          options = {:waitTime => options}
        end

        # check for jssh not running, firefox may be open but not with -jssh
        # if its not open at all, regardless of the :suppress_launch_process option start it
        # error if running without jssh, we don't want to kill their current window (mac only)
        jssh_down = false
        begin
          set_defaults()
        rescue Watir::Exception::UnableToStartJSShException
          jssh_down = true
        end

        if current_os == :macosx && !%x{ps x | grep firefox-bin | grep -v grep}.empty?
          raise "Firefox is running without -jssh" if jssh_down
          open_window unless options[:suppress_launch_process]
        elsif not options[:suppress_launch_process]
          launch_browser(options)
        end

        set_defaults(300)
        get_window_number()
        set_browser_document()
      end

      def set_defaults(no_of_tries = 3)
        no_of_tries_so_far = 0
        # JSSH listens on port 9997. Create a new socket to connect to port 9997.
        begin
          $jssh_socket = TCPSocket::new(MACHINE_IP, "9997")
          $jssh_socket.sync = true
          read_socket()
        rescue
          no_of_tries_so_far += 1
          sleep 0.1
          retry if no_of_tries_so_far < no_of_tries
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

if $baseURL then
  if not $baseURL.match(/\/$/) then
      $baseURL += '/'
  end
else
  $baseURL = "http://demo.silverstripe.com/"
end

# Make it go fast - IE only
# $browser.speed = :zippy

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
