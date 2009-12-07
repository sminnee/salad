Browser Salad
=============

Business-readable functional testing using browser automation: A salad of Cucumber, Watir, and a
bunch of browsers.

Installation
------------

Run `install` to install the necessary Ruby Gems and Firefox extensions.

Usage
-----

Run something like this to execute the tests.

   ./toss http://localhost/yoursite create-page.feature

**Note:** The command is `toss` because that's what you do to a salad.  It's a lame joke, but so is
the name Browser Salad.

Using Browser Salad to run tests from another project
-----------------------------------------------------

Browser Salad doesn't come bundled with any actual tests, so usually you have to write tests as part
of your project.


This example runs a copy of browsersalad installed in ~/browsersalad to execute the features 
contained in a Sapphire project.  `sake SapphireURL/baseurl` return the URL of the current Sapphire
project.

    ~/browsersalad/toss firefox `sake SapphireInfo/baseurl` */tests/cuke/*.feature

Because browsersalad was written in order to support testing of Sapphire projects, we have a special
script for this particular example.  This will probably go away as browsersalad matures

    ~/browsersalad/sapphiretoss firefox
