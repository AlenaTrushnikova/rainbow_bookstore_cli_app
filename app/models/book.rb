class Book < ActiveRecord::Base
    has_many :purchases
    has_many :shoppers, through: :purchases
end