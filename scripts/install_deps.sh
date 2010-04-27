#!/bin/sh

echo "Installing required gems to run salad"
sudo gem install cucumber rspec commonwatir
sudo gem install firewatir rb-appscript safariwatir 

#echo "Installing gems to build salad gem"
#sudo gem install hoe hoe-git

