# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
c = Company.create!(title: 'AWS')
Location.create(code: 'SYD', company: c)
Location.create(code: 'MEL', company: c)
u = User.create!(login: 'dan', email: 'test@mail.com', password: 'test1235',
  password_confirmation: 'test1235', role: :admin, company: c)

