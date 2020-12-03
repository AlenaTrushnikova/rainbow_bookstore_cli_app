require 'pry'

class Shopper < ActiveRecord::Base
    has_many :purchases
    has_many :books, through: :purchases

    def buy(book_title)
        book_id = Book.find_by(title: book_title).id 
        Purchase.create(book_id: book_id, shopper_id: self.id)
    end

    def return(book_title)
        book_id = Book.find_by(title: book_title).id
        Purchase.find_by(book_id:book_id, shopper_id:self.id).update(return?:true)
    end

end