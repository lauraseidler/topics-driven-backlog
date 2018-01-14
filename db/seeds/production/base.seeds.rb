# takes base seeds of development environment
# remove this to start with a clear database in production
base_seeds = '/../development/base.seeds.rb'
require File.expand_path(File.dirname(__FILE__))+base_seeds
