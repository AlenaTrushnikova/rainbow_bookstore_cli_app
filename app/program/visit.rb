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
        print "Glad you came in today, "
        print "#{@name.capitalize}".green
        print ". You have a budget of "
        print "$#{'%.2f' % @me.budget} ".green
        puts "for today's shopping."
        puts "What would you like to do? Here is a list of options:"
        puts "#{self.options}"
    end

    def options
        while true do
            puts "Main Menu".magenta
            puts "1. Purchase a book".red
            puts "2. Return a book".yellow
            puts "3. Browse by Category".green
            puts "4. Browse by Author".cyan
            puts "5. See top five sellers".blue
            puts "6. Check or update budget".magenta
            puts "7. Exit".red
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
            when "3"
                self.browse_cat
            when "4"
                self.browse_auth
            when "5"
                self.top_5
            when "6"
                self.budget_status
            else
                puts "Invalid input, please try again. "
            end
        end
        print "Goodbye, happy reading "
        print "#{@name.capitalize}".yellow
        puts "!"
    end

    def purchase
        print "What is the title of the book you'd like to buy? "
        input = STDIN.gets.chomp
        while input != 'return' do
            if Book.find_by(title: input) == nil
                print "Sorry, we don't have this book in our store.".red
                print "Try another title or type 'return' to go to the main menu. "
                input = STDIN.gets.chomp
            elsif @me.budget_check(Book.find_by(title: input).price)
                @me.buy(input)
                total = @me.budget_after_sale(Book.find_by(title: input).price)
                @me.update(budget: total)
                print "Thank you for buying #{input}, now fork over $#{'%.2f' % Book.find_by(title: input).price}. Your budget now is ".green
                print "$#{'%.2f' % @me.budget}".red
                puts ".".green
                puts "What would you like to do next? "
                break
            else
                puts "Sorry you don't have enough in your budget to buy this book.".red
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
                print "Sorry, you cannot return this book, you didn't buy it at this store. ".red
                print "Try another title or type 'return' to go to the main menu. "
                input = STDIN.gets.chomp
            else
                @me.update(budget: (@me.budget + purchase.book.price))
                print "Thank you for returning #{input}. We've returned $#{'%.2f' % purchase.book.price} and your budget is now " 
                print "$#{'%.2f' % @me.budget}".green
                puts "."
                purchase.destroy
                break
            end
        end       
    end

    def browse_cat
        puts "Categories:".magenta
        puts Book.categories
        print "Which category interests you? ".magenta
        input = STDIN.gets.chomp.capitalize
        print "Here are all books in the "
        print "#{input} ".green
        puts "category:"
        puts Book.all_by_category(input)
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end

    def browse_auth
        puts "Authors:".green
        puts Book.authors
        print "Which author interests you? ".green
        input = STDIN.gets.chomp.titleize
        print "Here are all books by "
        print "#{input}".green
        puts ":"
        puts Book.all_by_author(input)
        print "Type 'purchase' to buy a book, or press any key to go to the main menu. "
        input = STDIN.gets.chomp
        if input == 'purchase'
            self.purchase
        end
    end

    def top_5
        puts "Here are our Top 5 best sellers:".magenta
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
            puts "Your current budget is $#{'%.2f' % @me.budget}.".green
        elsif input == 'add'
            print "How much would you like to add? "
            money = STDIN.gets.chomp.to_f
            @me.update(budget: (@me.budget + money))
            puts "Your budget now is $#{'%.2f' % @me.budget}.".green
        else
            puts "Sorry, that's an invaild entry.".red
        end
    end
end