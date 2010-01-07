require 'rubygems'
require 'hoe'

Hoe.plugin :git

Hoe.spec 'browsercuke' do
  self.readme_file = 'README.md'

  developer('Sam Minnée', 'sam@silverstripe.com')
  
  extra_deps << ['cucumber', '>= 0.4.4']
  extra_deps << ['firewatir', '>= 1.6.5']
  
# We don't include these dependencies because they are OSX only.  If these are included, then you
# can't install the Gem on Windows.  Creating a browsercuke-osx gem might be a solution. 
#  extra_deps << ['safariwatir', '>= 0.3.7']
#  extra_deps << ['rb-appscript', '>= 0.5.3']
end