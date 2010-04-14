require 'rubygems'
require 'hoe'

Hoe.plugin :git

Hoe.spec 'salad-common' do
  self.readme_file = 'README.md'

  developer('Sam Minnée', 'sam@silverstripe.com')
  developer('Luke Hudson', 'luke@silverstripe.com')
  
  extra_deps << ['cucumber', '>= 0.6.3']
  extra_deps << ['rspec', '>= 1.2.9']
  extra_deps << ['firewatir', '>= 1.65']
  
end

Hoe.spec 'salad-safari' do
  self.readme_file = 'README.md'

  developer('Sam Minnée', 'sam@silverstripe.com')
  developer('Luke Hudson', 'luke@silverstripe.com')
  
  extra_deps << ['safariwatir', '>= 0.3.7']
  extra_deps << ['rb-appscript', '>= 0.5.3']
  extra_deps << ['salad-common', '>= 0.1.5']
end

Hoe.spec 'salad-ie' do
  self.readme_file = 'README.md'

  developer('Sam Minnée', 'sam@silverstripe.com')
  developer('Luke Hudson', 'luke@silverstripe.com')
  
  extra_deps << ['commonwatir', '>= 1.6.5']
  extra_deps << ['salad-common', '>= 0.1.5']
  
end
