require 'sinatra'
Bundler.require(:default)
Mongoid.load!("./config/mongoid.yml", Sinatra::Base.environment)
class Drivers < Sinatra::Base
end

# config/initializers/state_machine_patch.rb
# See https://github.com/pluginaweek/state_machine/issues/251
module StateMachine
  module Integrations
     module ActiveModel
        public :around_validation
     end
  end
end


require './app/models/driver'
require './app/models/task'
require './app/models/manager'
require './app/models/token'
require './app/controllers/tasks_controller'
