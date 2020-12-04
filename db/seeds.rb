require_relative '../config/environment.rb'

Book.destroy_all
Shopper.destroy_all
Purchase.destroy_all

20.times do
Book.create(title:Faker::Book.title, category: Faker::Book.genre, author: Faker::Book.author, price: rand(1..20).to_f)
end

10.times do
Shopper.create(name:Faker::Name.name, budget: rand(1..100).to_f)
end

30.times do
Purchase.create(book_id: Book.all.sample.id, shopper_id: Shopper.all.sample.id)
end

puts "done"