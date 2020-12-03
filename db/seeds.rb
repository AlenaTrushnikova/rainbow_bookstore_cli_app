require_relative '../config/environment.rb'

Book.destroy_all
Shopper.destroy_all
Purchase.destroy_all

100.times do
Book.create(title:Faker::Book.title, category: Faker::Book.genre, author: Faker::Book.author, price: rand(1..20).to_f, language:Faker::Nation.language)
end

20.times do
Shopper.create(name:Faker::Name.name, age: rand(10..100))
end

30.times do
Purchase.create(book_id: Book.all.sample.id, shopper_id: Shopper.all.sample.id)
end

puts "done"