# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Account.delete_all
Person.delete_all
a= Account.create(name: 'mdl')
Person.create(name: 'Karan Arora',email: 'mail@arorakaran.com', hired_on: Date.today, bio: 'RoR dev', account_id: a.id )