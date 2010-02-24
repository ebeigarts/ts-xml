$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__) + '/../vendor/thinking_sphinx/lib'

require 'spec/rake/spectask'
require 'cucumber/rake/task'

namespace :features do
  def add_task(name, description)
    Cucumber::Rake::Task.new(name, description) do |t|
      t.cucumber_opts = "-r spec/cucumber_env.rb -r features/step_definitions --format pretty DATABASE=#{name}"
    end
  end
  
  add_task :mysql,      "Run feature-set against MySQL"
  add_task :postgresql, "Run feature-set against PostgreSQL"
  add_task :oracle,     "Run feature-set against Oracle"
  add_task :sqlite3,    "Run feature-set against SQLite3"
end

namespace :thinking_sphinx do
  # Initialize test enviroment for ts:xml rake task
  task :app_env do
    # Establish DB connection
    if ENV['DATABASE']
      require "thinking_sphinx"
      require "thinking_sphinx/xml"
      require "cucumber"
      require "cucumber/thinking_sphinx/internal_world"
      world = Cucumber::ThinkingSphinx::InternalWorld.new
      world.configure_database
      world.send(:load_files, world.send(:models_directory))
    end
  end
end
