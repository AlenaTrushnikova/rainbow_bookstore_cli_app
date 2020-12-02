class Purchase < ActiveRecord::Base
    belongs_to :book
    belongs_to :shopper

    
end