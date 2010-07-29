##W WINDOWS AND IFRAMES

Given /look in the window "(.*)"[., \t]*$/i do |text|
    found = @salad.attach(:title, text)
    found = @salad.attach(:url, text) unless found
    if not found
        fail("could not find the '#{text}' window")
    end
end

Given /I inspect "([^"]+)"[., \t]*$/i do |what|
	elt = @salad.getElement('frame', what, [:index, :name, :id, :src])
	if elt then
		@salad.setNextContainer(elt)
	else
		fail("Didn't find a frame called #{what}")
	end
end

Given /I inspect the whole page[., \t]*$/ do
	@salad.resetContainer()
end

Given /(.*) within "([^"]+)"[., \t]*$/i do |command, iframe|
  Given "I inspect \"#{iframe}\""
  Given command
  Given "I inspect the whole page"
end