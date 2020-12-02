require 'pry'
class Shopper < ActiveRecord::Base
    has_many :purchases
    has_many :books, through: :purchases

    def buy(book_title)
        book_id = Book.find_by(title: book_title).id      
        Purchase.create(book_id: book_id, shopper_id: self.id)
    end

    
end