#!/bin/sh
PEAR='/Applications/MAMP/bin/php5/bin/pear'

echo "Installing PHPUnit for MAMP"
sudo $PEAR channel-discover pear.phpunit.de
sudo $PEAR channel-discover pear.symfony-project.com
sudo $PEAR upgrade PEAR
sudo $PEAR install phpunit/PHPUnit

echo "Please check installation by visiting dev/tests in SilverStripe, and ensure you get no error message"
