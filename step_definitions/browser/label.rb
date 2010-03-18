# extend browser to provide label()

module FireWatir
  module Container

    def label(how, what = nil)
      locate if respond_to?(:locate)
      return Label.new(self, how, what)
    end

	end
end