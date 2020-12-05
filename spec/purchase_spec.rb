require_relative '../config/environment.rb'
require 'pry'
ActiveRecord::Base.logger = nil

describe 'Shopper Class' do
    before do
        @sara = Shopper.find_or_create_by(name:"Sara", budget: 50.00)
        @book = Book.find_or_create_by(title: "Title", price:10.00)
    end
    it "Buy method adds a book to shopper's list." do
        @sara.buy("Title")
        expect(@sara.books.last).to(eq(@book))  
    
#Correct way to test this? We are running two methods here... ?
    it "Subtracts book price from budget." do
        total = @sara.budget_after_sale(10.00)
        @sara.update(budget: total)
        expect(@sara.budget).to(eq(40.00))
    end

end
