require_relative '../config/environment'
require_relative '../app/program/bookstore.rb'

puts "Welcome to All Languages Bookstore!"
puts "What is your name?"
name = gets.chomp
puts "And what is your age?"
age = gets.chomp

visit = Visit.new(name, age)
visit.go
