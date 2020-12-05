require_relative '../config/environment'
require_relative '../lib/bookstore.rb'
require 'colorize'
ActiveRecord::Base.logger = nil #disables SQL query logging



print "Welcome to ".green
print "R".magenta
print "A".red
print "I".yellow
print "N".green
print "B".cyan
print "O".blue
print "W".magenta
puts " Bookstore".green
print "What is your name? "
name = STDIN.gets.chomp
print "What is your budget today? "
budget = STDIN.gets.chomp.to_f

visit = Visit.new(name, budget)
visit.go