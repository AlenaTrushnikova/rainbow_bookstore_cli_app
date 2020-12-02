require_relative '../config/environment.rb'

b1 = Book.create(title: "Atlas Shrugged", author: "Ayn Rand", price: 10.00, category: "Political", language: "English")

b2 = Book.create(title: "War and Peace", author: "Fedor Tolstoy", price: 6.00, category: "Novel", language: "Russian")

s1 = Shopper.create(name: "Willow", age: 5)
s2 = Shopper.create(name: "Nika", age: 28)

p1 = Purchase.create(book: b1, shopper: s1)
p2 = Purchase.create(book: b2, shopper: s2)
p3 = Purchase.create(book: b1, shopper: s2)
