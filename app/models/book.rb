require 'pry'
class Book < ActiveRecord::Base
    has_many :purchases
    has_many :shoppers, through: :purchases

    def self.all_by_category(cat)
        Book.where(category: cat).map{|book| book}
    end

    def self.all_by_author(author)
        Book.where(author: author).map{|book| book}
    end

    def num_purchases
        Purchase.all.select{|pur| pur.book_id ==  self.id && pur.return? == false}.count
    end

    def self.best
        Book.all.max_by{|book| book.num_purchases}
    end

    def self.top_5
        Book.all.sort_by{|book| book.num_purchases}.reverse[0..4]
    end

end