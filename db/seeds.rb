# db/seeds.rb
items = [
  {id: 1, name: "Book", value: "10"},
  {id: 2, name: "Paper", value: "500"},
  {id: 3, name: "Glue", value: "Out of stock"}
]

items.each do |u|
  Items.create(u)
end
