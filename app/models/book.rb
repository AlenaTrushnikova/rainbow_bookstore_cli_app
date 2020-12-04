require 'pry'
class Book < ActiveRecord::Base
    has_many :purchases
    has_many :shoppers, through: :purchases

    def self.all_by_category(cat)
        Book.where(category: cat).map{|book| book.title}
    end

    def self.categories
        Book.all.map{|book| book.category}.uniq.each{|cat| puts cat}
    end

    def self.authors
        Book.all.map{|book| book.author}.uniq.each{|auth| puts auth}
    end

    def self.all_by_author(author)
        Book.where(author: author).map{|book| book.title}
    end

    def num_purchases
        Purchase.all.select{|pur| pur.book_id ==  self.id && pur.return? == false}.count
    end

end