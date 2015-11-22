# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
SuperAdmin.create!(email: 'daniel.g.myasnikov@gmail.com', password: 'test1234', password_confirmation: 'test1234')
SuperAdmin.create!(email: 'a.myasnikov@gmail.com', password: 'test1234', password_confirmation: 'test1234')AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')