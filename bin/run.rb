require_relative '../config/environment'
require_relative '../app/program/bookstore.rb'

puts "Welcome to All Languages Bookstore!"
print "What is your name? "
name = STDIN.gets.chomp
print "What is your budget today? "
budget = STDIN.gets.chomp.to_f

visit = Visit.new(name, budget)
visit.go