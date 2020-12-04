require_relative '../config/environment'
require_relative '../app/program/bookstore.rb'
require 'colorize'
ActiveRecord::Base.logger = nil #disables SQL query logging



puts "Welcome to Bookstore!".green
print "What is your name? "
name = STDIN.gets.chomp
print "What is your budget today? "
budget = STDIN.gets.chomp.to_f

visit = Visit.new(name, budget)
visit.go