require_all 'app'
require 'pry'

class Visit
    attr_reader :name, :age, :me
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
        puts "Main Menu\n1. Purchase a book\n2. Return a book\n3. Browse by Category\n4. Browse by Author\n5. See top sellers\n6. exit"
        print "Please enter a number, or type 'exit'. "
        input = STDIN.gets.chomp
        while input != 'exit' && input != "6" do
            case input.downcase
            when "1"
                self.purchase
            when "2"
                self.return
            when "3"
            when "4"
            when "5"
            else
                print "Invalid input, please try again."
                input = STDIN.gets.chomp
            end
        end
    end

    def purchase
        print "What is the title of the book you'd like to buy? "
        input = STDIN.gets.chomp
        while input != 'return' do
            if Book.find_by(title: input) == nil
                print "Sorry, we don't have this book in our store. Try another title or type 'return' to go to the main menu. "
                input = STDIN.gets.chomp
            else
                Shopper.find(@me.id).buy(input)
                puts "Thank you for buying #{input}, now fork over $#{Book.find_by(title: input).price}."
                print "What would you like to do next?"
                self.options
            end
        end
        self.options
    end

    def return
        print "What is the title of the book you'd like to return? "
        input = STDIN.gets.chomp
        while input != 'return' do
            if old_purchase = @me.purchases.select{|pur| pur.book.title == input}[0]
                old_purchase.update(return?:true)
                puts "Thank you for returning #{input}"
                self.options
            else
                puts "Sorry, you cannot return this book, you didn't buy it at this store."
                self.options
            end
        end
    end
    
end
