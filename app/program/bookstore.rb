require_all 'app'
require 'pry'

class Visit
    attr_reader :name, :budget, :me
    def initialize(name, budget)
        @name = name
        @budget = budget
        @me = Shopper.create(name: @name, budget: @budget)
    end

    def go
        puts "Glad you came in today, #{@name}.\n"
        puts "What would you like to do? Here is a list of options:"
        puts "#{self.options}"
    end

    def options
        while true do
            puts "Main Menu\n1. Purchase a book\n2. Return a book\n3. Browse by Category\n4. Browse by Author\n5. See top five sellers\n6. Exit"
            print "Please enter a number, or type 'Exit'. "
            input = STDIN.gets.chomp

            if input.downcase == 'exit' || input == "6"
                break
            end

            case input.downcase
            when "1"
                self.purchase
            when "2"
                self.return
            when "3"
                self.browse_cat
            when "4"
                self.browse_auth
            when "5"
                self.top_5
            else
                print "Invalid input, please try again. "
                input = STDIN.gets.chomp
            end
        end
        puts "Goodbye, happy reading #{@name}!"
    end

    def purchase
        print "What is the title of the book you'd like to buy? "
        input = STDIN.gets.chomp
        while input != 'return' do
            if Book.find_by(title: input) == nil
                print "Sorry, we don't have this book in our store. Try another title or type 'return' to go to the main menu. "
                input = STDIN.gets.chomp
            elsif @me.budget_check(Book.find_by(title: input).price)
                Shopper.find(@me.id).buy(input)
                x = @me.budget_after_sale(Book.find_by(title: input).price)
                @me.update(budget: x)
                puts "Thank you for buying #{input}, now fork over $#{Book.find_by(title: input).price}."
                print "What would you like to do next? "
                break
            else
                puts "Sorry you don't have enough in your budget to buy this book."
                break
            end
        end
    end

    def return
        print "What is the title of the book you'd like to return? "
        input = STDIN.gets.chomp
            if purchase = @me.purchases.select{|pur| pur.book.title == input}[0]
                purchase.destroy
                puts "Thank you for returning #{input}"
            else
                puts "Sorry, you cannot return this book, you didn't buy it at this store."
            end        
    end

    def browse_cat
        puts "Categories:"
        puts Book.categories
        print "Which category interests you? "
        input = STDIN.gets.chomp
        puts "Here are all books in the #{input} category:"
        puts Book.all_by_category(input)
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end

    def browse_auth
        puts "Authors:"
        puts Book.authors
        print "Which author interests you? "
        input = STDIN.gets.chomp
        puts "Here are all books by #{input}:"
        puts Book.all_by_author(input)
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end

    def top_5
        puts "Here are our Top 5 best sellers:"
        # Is this too long? Better to assign variables? Or better to include methods in Book class?
        Book.all.sort_by{|book| book.num_purchases}.reverse[0..4].each{|book| puts book.title}
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end
end
