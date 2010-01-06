= BrowserCuke

http://github.com/sminnee/browsercuke

== DESCRIPTION:

BrowserCuke is a layer of browser-based testing on top of Cucumber.  It provides an intuitive way of
writing business-readable tests for your web applications, that use real web browsers to test.  Your
test scripts can now be a way of communicating with your client how you have tested the application 
and how it should work.

For more information about Cucumber, see [the cucumber website](http://cukes.info).

BrowserCuke currently uses Watir to perform the browser automation, although it may be extended in 
the future to use something like WebRat to test applications sans-JavaScript.

== FEATURES

 * Tests Safari and Firefox
 * Looks for page elements like a human would: e.g. ignores hidden elements, and you can use form element labels as identifiers.
 * Automatically wait for ajax requests to complete.

It currently has the following limitations:

 * No known Windows and IE support
 * No ability to test with JavaScript
 * Ajax auto-wait only works with Prototype and jQuery generated Ajax requests.
 * Testing of iframes and multiple windows is untested.
 * No drag & drop tests.

Roadmap:

 * Make it work in Windows/OSX/Linux and Firefox/Safari/IE
 * Add JS-disabled testing using WebRat
 * Ensure that you can test iframes and multiple windows intuitively
 * Add tests for drag & drop
 * Add tests for colour and image changes
 * Get the FireWatir and SafariWatir monkey patches submitted to those upstream projects.

== INSTALL:

BrowserCuke is packaged as a gem, so the easiest way of installing BrowserCuke is by running this
command:

  $ gem install browsercuke

After you have installed the gem, you should run this command to set up your browsers properly:

  $ browsercuke-setup

== SYNOPSIS:

Run something like this to execute a test freature.

   browsercuke http://localhost/yoursite create-page.feature

=== Using BrowserCuke to run tests from another project

BrowserCuke doesn't come bundled with any actual tests, so usually you have to write tests as part
of your project.


This example runs a copy of BrowserCuke installed in ~/browsercuke to execute the features 
contained in a Sapphire project.  `sake SapphireURL/baseurl` return the URL of the current Sapphire
project.

    browsercuke firefox `sake SapphireInfo/baseurl` */tests/cuke/*.feature

Because BrowserCuke was written in order to support testing of Sapphire projects, we have a special
script for this particular example.  This will probably go away as BrowserCuke matures

    sapphirecuke firefox

=== Rules

Please see [the cucumber website](http://cukes.info) for information about the exact cucumber 
syntax.

Actions
-------

### When I click the "(identifier)" button

### When I click the "(identifier)" checkbox

### When I click the "(identifier)" image

### When I click the "(identifier)" link

### When I click the "(identifier)" radio button

### When I visit (url)

### When I select "(value)" from "(dropdown identfier)"

### When I put "(value)" in the "(field identifier)" field / When I set "(field)" to "(value)"

Assertions
----------

### Then I see "(text)"

### Then I don't see "(text)"

### Then I am at (url) / Then I am sent to (url)

### Then the url (url) does not exist

### Then "(value)" is selected in "(dropdown identfier)"

### Then the "(identifier)" field is "(value)" / Then the "(identifier)" field becomes "(value)"

### Then the "(identifier)" field is blank



Waiting
-------

### I wait for "(text)"

### I wait for HTML ("html")

Misc
----

### I cancel pop-ups

### I confirm pop-ups

### I put "(text)" in the pop-up

-----

Recommended amendment - we should alter the rules to operate this way:

Actions
-------

### When I click "(button/image/link/checkbox/radiobutton)"

### When I visit "(url)"

### When I set "(dropdown/textfield)" to "(value)"

Assertions
----------

### Then I see "(text)"

### Then I don't see "(text)"

### Then I am at (url)

### Then the url (url) doesn't exist

### Then "(field/dropdown)" is "(value)"

### Then "(checkbox/radio)" is selected

### Then "(checkbox/radio)" isn't selected

### Then "(identifier)" is blank


Waiting
-------

### I wait for "(text)"

### I wait for HTML ("html")

Misc
----

### I cancel pop-ups

### I confirm pop-ups

### I put "(text)" in pop-ups

== REQUIREMENTS:

Currently browsercuke works with the following browsers.

 * Firefox 3.5
 * Safari

It has been tested on OS X only; Windows and IE support coming soon!

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

Browsercuke is licensed under the BSD license

Copyright (c) 2009, Sam Minnée
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