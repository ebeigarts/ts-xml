require 'jeweler'
require 'yard'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'ts-xml'
  gem.summary     = 'Thinking Sphinx + XML'
  gem.description = 'Thinking Sphinx plugin for xmlpipe2 data sources (Oracle, SQLite3, ...)'
  gem.email       = "1@wb4.lv"
  gem.homepage    = "http://github.com/ebeigarts/ts-xml"
  gem.authors     = ["Edgars Beigarts"]
  
  gem.add_dependency 'thinking-sphinx', '>= 1.3.8'
  
  gem.add_development_dependency "rspec",    ">= 1.2.9"
  gem.add_development_dependency "yard",     ">= 0"
  gem.add_development_dependency "cucumber", ">= 0"
  
  gem.files = FileList[
    'lib/**/*.rb',
    'LICENSE',
    'README.textile'
  ]
end

Jeweler::GemcutterTasks.new
