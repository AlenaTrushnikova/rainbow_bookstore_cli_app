require_all 'app'
require 'pry'

class Visit
    attr_reader :name, :age
    def initialize(name, age)
        @name = name
        @age = age
        @me = Shopper.create(name: @name, age: @age)
    end

    def go
        puts "Glad you came in today, #{@name}."
        puts "What would you like to do? Here is a list of options:"
        puts "#{self.options}"
    end

    def options
        puts "1. Purchase a book\n2. Return a book\n3. Browse by Category\n4. Browse by Author\n5. See top sellers"
        print "Please enter a number, or type 'exit'."
        option = gets.chomp
        while option != 'exit' do
            case option.downcase
            when "1"
                self.purchase
            when "2"
            when "3"
            when "4"
            when "5"
            else
                print "Invalid input, please try again."
                option = gets.chomp
            end
        end
    end

    def purchase
        print "What is the title of the book you'd like to buy? "
        response = gets.chomp
        while response != 'return'
            if Book.find_by(title: response) == nil
                puts "Sorry, we don't have this book in our store. Try another title or type 'return'."
                response = gets.chomp
            else
                Shopper.find(@me.id).buy(response)
                puts "Thank you for buying #{response}, now fork over $#{Book.find_by(title: response).price}."
                print "What would you like to do next?"
                self.options
            end
        end
        puts "Choose a new option."
        self.options
    end
end
