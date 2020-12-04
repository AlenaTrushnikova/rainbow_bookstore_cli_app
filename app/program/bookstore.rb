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
        puts "Glad you came in today, #{@name}. You have a budget of $#{'%.2f' % @me.budget} for today's shopping.".green
        puts "What would you like to do? Here is a list of options:"
        puts "#{self.options}"
    end

    def options
        while true do
            puts "Main Menu\n1. Purchase a book\n2. Return a book\n3. Browse by Category\n4. Browse by Author\n5. See top five sellers\n6. Check or update budget\n7. Exit"
            print "Please enter a number, or type 'Exit'. "
            input = STDIN.gets.chomp

            if input.downcase == 'exit' || input == "7"
                break
            end

            case input.downcase
            when "1"
                self.purchase
            when "2"
                self.return
                #puts "return done"
            when "3"
                self.browse_cat
            when "4"
                self.browse_auth
            when "5"
                self.top_5
            when "6"
                self.budget_status
            else
                print "Invalid input, please try again. "
                input = STDIN.gets.chomp
            end
            #puts 'end of while'
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
                puts "Thank you for buying #{input}, now fork over $#{'%.2f' % Book.find_by(title: input).price}. Your budget now is $#{'%.2f' % @me.budget}.".green
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

        while input != 'return' do
            purchase = @me.purchases.select{|pur| pur.book.title == input}[0]
            if  purchase == nil
                print "Sorry, you cannot return this book, you didn't buy it at this store. Try another title or type 'return' to go to the main menu. "
                input = STDIN.gets.chomp
            else
                @me.update(budget: (@me.budget + purchase.book.price))
                puts "Thank you for returning #{input}. You've got your $#{'%.2f' % purchase.book.price} back. And your budget now is $#{'%.2f' % @me.budget}.".green
                purchase.destroy
                break
            end
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
        Book.all.sort_by{|book| book.num_purchases}.reverse[0..4].each{|book| puts book.title}
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end

    def budget_status
        print "Type 'check' to see your current budget or 'add' to add money to your budget. "
        input = STDIN.gets.chomp
        if input == 'check'
            puts "Your current budget is $#{'%.2f' % @me.budget}."
        elsif input == 'add'
            print "How much would you like to add? "
            money = STDIN.gets.chomp.to_f
            #check if user's input is valid
            @me.update(budget: (@me.budget + money))
            puts "Your budget now is $#{'%.2f' % @me.budget}.".green
        else
            puts "Sorry, that's an invaild entry."
        end
    end
end
