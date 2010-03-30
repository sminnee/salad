Given /look in the window "(.*)"/i do |text|
    found = @salad.attach(:title, text)
    found = @salad.attach(:url, text) unless found
    if not found
        fail("could not find the '#{text}' window")
    end
end
