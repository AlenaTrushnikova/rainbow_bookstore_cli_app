require 'pry'
class Book < ActiveRecord::Base
    has_many :purchases
    has_many :shoppers, through: :purchases

    def self.find_by_category(cat)
        Book.where(category: cat).map{|book| book.title}
    end

    def self.find_by_author(author)
        Book.where(author: author).map{|book| book.title}
    end
end