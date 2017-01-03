require 'sinatra'
require 'mongoid'
require 'state_machine'
class Drivers < Sinatra::Base
end
require './app/models/driver'
require './app/models/task'
require './app/models/manager'
require './app/models/token'
require './app/controllers/tasks_controller'
