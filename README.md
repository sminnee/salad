BrowserCuke
===========

BrowserCuke is a layer of browser-based testing on top of Cucumber.  It provides an intuitive way of
writing business-readable tests for your web applications, that use real web browsers to test.  Your
test scripts can now be a way of communicating with your client how you have tested the application 
and how it should work.

For more information about Cucumber, see [the cucumber website](http://cukes.info).

BrowserCuke currently uses Watir to perform the browser automation, although it may be extended in 
the future to use something like WebRat to test applications sans-JavaScript.

Installation
------------

Run `install` to install the necessary Ruby Gems and Firefox extensions.

Usage
-----

Run something like this to execute a test freature.

   ./browsercuke http://localhost/yoursite create-page.feature

Using BrowserCuke to run tests from another project
---------------------------------------------------

BrowserCuke doesn't come bundled with any actual tests, so usually you have to write tests as part
of your project.


This example runs a copy of BrowserCuke installed in ~/browsercuke to execute the features 
contained in a Sapphire project.  `sake SapphireURL/baseurl` return the URL of the current Sapphire
project.

    ~/browsercuke/browsercuke firefox `sake SapphireInfo/baseurl` */tests/cuke/*.feature

Because BrowserCuke was written in order to support testing of Sapphire projects, we have a special
script for this particular example.  This will probably go away as BrowserCuke matures

    ~/browsercuke/sapphirecuke firefox