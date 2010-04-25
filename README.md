# Salad

http://github.com/sminnee/salad

## DESCRIPTION

Salad is a layer of browser-based testing on top of Cucumber.  It provides an intuitive way of
writing business-readable tests for your web applications, that use real web browsers to test.  Your
test scripts can now be a way of communicating with your client how you have tested the application 
and how it should work.

For more information about Cucumber, see [the cucumber website](http://cukes.info).

Salad currently uses Watir to perform the browser automation, although it may be extended in 
the future to use something like WebRat to test applications sans-JavaScript.

## FEATURES

 * Tests Safari, Firefox and IE
 * Looks for page elements like a human would: e.g. ignores hidden elements, and you can use form element labels as identifiers.
 * Automatically wait for ajax requests to complete.

It currently has the following limitations:

 * No ability to test with JavaScript
 * Ajax auto-wait only works with Prototype and jQuery generated Ajax requests.
 * Testing of iframes is untested.
 * No drag & drop tests.

Roadmap:

 * Add JS-disabled testing using WebRat
 * Ensure that you can test iframes intuitively
 * Add tests for drag & drop
 * Add tests for colour and image changes
 * Get the FireWatir and SafariWatir monkey patches submitted to those upstream projects.

## INSTALL

Salad is packaged as a Ruby gem.  There are also a few platform-specific steps that you need
to perform.  Platform-specific installation instructions are as follows.

### Windows

On Windows, we recommend that you use Ruby 1.8.6 and not a more recent version.  If you use a
different version of Ruby, you will also need to install build tools to compile native extensions.

[You can download the one-click installer here](http://rubyforge.org/frs/download.php/29263/ruby186-26.exe)

You will then need to update RubyGems.  [Download from here](http://gemcutter-production.s3.amazonaws.com/rubygems/rubygems-1.3.5.zip), extract, and run
this command from a command-line prompt within the rubygems-1.3.5 directory that it contains:

    $ ruby setup.rb

Now, run this command:

    $ gem install salad watir win32console

Finally, install the Firefox extension, JSSH.  You can download it here:

 * [Firefox 2.0/Win](http://wiki.openqa.org/download/attachments/13893658/jssh-WINNT-2.x.xpi)
 * [Firefox 3.0/Win](http://wiki.openqa.org/download/attachments/13893658/jssh-20080708-WINNT.xpi)
 * [Firefox 3.5/Win](http://wiki.openqa.org/download/attachments/13893658/jssh-3.5.x-WINNT.xpi)
 * [Firefox 3.6/Win](http://wiki.openqa.org/download/attachments/13893658/jssh-3.6-WINNT.xpi?version=1&modificationDate=1264489925906)

You are now set up to run salad tests on IE and Firefox.

### OS X

#### EASY INSTALL

Your milage may vary.

Checkout the salad source:

    $ cd ~/Sites
    $ git clone git@github.com:sminnee/salad.git salad
	$ cd salad

Set up Firefox for Salad

	1. First, run ./scripts/firefox-3.6.sh (or 3.5.sh for older version)
	2. This should show the Firefox Profile Manager
	3. Create a Profile named "Salad" (case sensitive, no quotes), and select it.
	4. Click "Start Firefox"
	5. Follow the install instructions for JSSH
	6. Don't restart Firefox yet!
	7. Open Firefox Preferences->Content and de-select "Block pop-up windows"
	8. Quit Firefox

Now, install PHPUnit.  These scripts are for MAMP or XAMPP.  For other systems, use your *-fu.

	Run one of these:

    $ ./scripts/install_phpunit_MAMP.sh # (For MAMP)
    $ ./scripts/install_phpunit_XAMPP.sh # (For XAMPP)

Now install the gems:

    $ ./scripts/install_deps.sh

Now, test salad itself:

    $ ./bin/salad firefox http://localhost/salad tests/*.feature


#### NORMAL INSTALL
If you have Leopard or Snow Leopard, then you should have Ruby all set up.  Open Terminal and
run this command:

    $ gem install salad safariwatir rb-appscript

Go to System Prefences -> Universal Access and check the box labelled 'Enable access for assistive devices'.

Finally, install the Firefox extension, JSSH.  You can download it here:

 * [Firefox 2.0/OS X](http://wiki.openqa.org/download/attachments/13893658/jssh-darwin-0.94.xpi?version=1)
 * [Firefox 3.0/OS X](http://wiki.openqa.org/download/attachments/13893658/jssh-20080924-Darwin.xpi)
 * [Firefox 3.5/OS X](http://wiki.openqa.org/download/attachments/13893658/jssh-3.5.x-Darwin-param.xpi)
 * [Firefox 3.6/OS X](http://wiki.openqa.org/download/attachments/14188672/jssh-3.6-OSX.xpi)

You are now set up to run salad tests on Safari an Firefox.

## SYNOPSIS

Now it's time to create your first test.  As an example, we will test Google's search.  Create a
file called `google-search.feature` and put this content into it.

    Feature: Google Search
    	As a user of the web
    	I want to search for interesting websites
    	So that I can find things on the web.

    	Scenario: Search for SilverStripe
    		Given I visit /
    		When I put "SilverStripe" in the "q" field
    		And I click the "Google Search" button
    		Then I see "www.silverstripe.com"
    		And I see "Open Source CMS / Framework"

Run your test with this command.  You should see the text of your test printed in green, as it
executes each line of the test.

    $ salad firefox http://www.google.com google-search.feature

The arguments are as follows:

 * `firefox` - the first argument specifies the browser: "firefox" or "safari" or "ie"
 * `http://www.google.com` - the second argument specifies the root URL of your site.  All URLs in
   the test are specified relative to this URL.  That makes it easy to run your tests on different
   instances of your application.
 * `google-search.feature` - the final argument is the name of the .feature file to run.  You can
   pass multiple files, or use wildcards, if you prefer.

In addition to these arguments, you can pass any other cucumber arguments.  Call `cucumber --help`
for more information.

### Using Salad to run tests from another project

Salad doesn't come bundled with any actual tests, so usually you have to write tests as part
of your project.

This example runs a Salad to execute the features contained in a Sapphire project
`sake SapphireURL/baseurl` return the URL of the current Sapphire project.

    salad firefox `sake SapphireInfo/baseurl` */tests/cuke/*.feature

Because Salad was written in order to support testing of Sapphire projects, we have a special
script for this particular example.  This will probably be merged into Sapphire as Salad
matures.

    sapphiresalad firefox

### Rules

Please see [the cucumber website](http://cukes.info) for information about the exact cucumber 
syntax.

You should (in theory) be able to specify a field, link, or button by: ID,name,value,class,text,label or url

== Actions ==

* Given I visit "http://www.example.com"
* Given I click "image | button | link | checkbox | etc.."
* Given I set "First Name" to "Hans"
  * This should work for text fields, password fields and drop-downs.
* Given I set "Surname" to "Dampf"
* Given I select "item two" from "ID_SelectBoxA"
  * This should work for drop-downs. 

== Assertions ==

* Then "Field" is selected
* Then "Field" is checked
* Then "Field" is not selected
* Then "Field" is not checked
  * 'selected' and 'checked' are synonyms and should work for checkboxes and radio buttons.
* Then "Field" is "value"
* Then "Field" is set to "value"
  * These two above are synonyms, and should work for text fields, passwords, textareas and drop-downs.
* Then I am at http://url.example.com
* Then I am sent to www.newsite.example.com
* Then I see "some text on the page"
* Then I don't see "some error message text"
* Then I am at "www.google.com"
* Then I am sent to "www.google.com"
* Then the "Surname" field is blank

== Windows ==

These statements affect which window is used for the assertions and actions that follow them.

* And I look in the window "http://www.google.com"
* And I look in the window "Google"

== Popups ==

These statements affect any popup alert, input, or confirmation popup boxes that are created after the statement is issued.

    Eg:
       Given I cancel popups
       And I click the "Delete"
       Then I see "Cancelled"

* Given I confirm popups
* Given I cancel popups
* Given I put "my response" in the popup
  * This is for a popup input dialog.

== Waiting ==

* And I wait 5s
* And I wait for html "<span>test</span>"


## REQUIREMENTS

Currently salad works with the following browsers.

 * Firefox 3.5 / 3.6
 * Safari (unsure of version limits)
 * IE (unsure of version limits)

It has been tested on OS X and Windows only.

## COMMON PROBLEMS

### Firefox running without JSSH.
The best way to test with Firefox is to run Firefox with the command-line argument -ProfileManager, and create a new profile for Salad, and load this.  Install the JSSH extension into this profile, then quit Firefox and run Salad.

### Multiple window tests failing.  
Check that the Popup blocker for your browser is not running, or is at least set to allow the domain you're testing.

## DEVELOPERS

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

To create a new release of the gem, to the following:

 * Update the version number in lib/salad.rb
 * Rebuild the manifest.  If it fails initially, create a manifest containaining only 
   `lib/salad.rb` and re-execute.

         rake git:manifest

 * Call `rake git:changelog` and put the result at the top of History.txt, with the appropriate
   version number
 * Commit the changes to lib/salad.rb and History.txt with commit message like "Created vX.Y.Z"
 * Package the gem and release it to Gemcutter

         rake publish

To run the salad self tests, you should symlink the salad source tree into a place
accessible by a URL.  For example, you might check it out into `~/Sites/salad`, which is 
accessible at `http://localhost/salad`.  You can then run the test suite like so:

    cd ~/Sites/salad
    salad ie|firefox|safari http://localhost/salad tests/*.feature

## LICENSE

Salad is licensed under the BSD license

Copyright (c) 2009, SilverStripe Limited  
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
