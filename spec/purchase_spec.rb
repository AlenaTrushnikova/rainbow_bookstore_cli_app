require_relative '../config/environment.rb'
require 'pry'
ActiveRecord::Base.logger = nil

describe 'Shopper Class' do
    before do
        @sara = Shopper.create
        @book = Book.find_or_create_by(title: "Title")
    end
    it "Buy method adds a book to shopper's list." do
        @sara.buy("Title")
        expect(@sara.books.last).to(eq(@book))  
       
    end
end

describe 'Visit Class' do
    before do
        @visit = Visit.new("Bill", 50.00)
        @book = Book.find_or_create_by(title:"Title2", price:10.00)
    end
    it "Purchase method subtracts book price from shopper's budget." do
        @visit.purchase("Title2")
        expect(@visit.me.budget).to(eq(40.00))
    end
end