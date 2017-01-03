# encoding: utf-8
ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler/setup'
require 'rack/test'

# Load the application
require './drivers.rb'

# Load the test frameworks
require 'rspec'
Mongoid.load!(File.join(File.dirname(__FILE__), '../config', 'mongoid.yml'), 'test')

RSpec.configure do |c|
  c.filter_run :focus => true
  c.color = true
  c.run_all_when_everything_filtered = true
  c.deprecation_stream = '/dev/null'
end
