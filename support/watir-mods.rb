=begin

This is a collection of modifications to SafariWatir to get it to work more consistently with the
Watir API

=end

if $browserName and $browserName.downcase == 'ie'

  require 'watir'

  module Watir

    class IE
      def resetContainer
        self.set_container(self.document)
      end
    end # class IE

    class Frame
    
      def exists?
        begin
          locate if defined?(locate)
        rescue WIN32OLERuntimeError
          @o = nil
        end
        @o ? true: false
      end # exists?

      def visible?
        object = @o
        begin
          if object.currentstyle.invoke('visibility') =~ /^hidden$/i
            return false
          end
          if object.currentstyle.invoke('display') =~ /^none$/i
            return false
          end
          if object.invoke('isDisabled')
            return false
          end
        rescue WIN32OLERuntimeError
        end
        return true
      end # visible?

    end # class Frame
  end # module Watir

end # if $browserName ..
