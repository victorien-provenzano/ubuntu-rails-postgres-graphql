# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Article.destroy_all
Article.new(title: "Hello Rails", body: "I am on Rails!").save
Article.new(title: "Hello World", body: "Hello World!").save
Article.new(title: "Hello Solutions Engineers", body: "Welcome to this sandbox!").save
