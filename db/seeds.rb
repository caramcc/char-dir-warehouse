# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

devs = [
  {
    username: 'aya',
    display_name: 'Aya',
    group: 'ADMIN',
    email: 'dominate.earth@gmail.com',
    password_digest: '$2a$10$t5KS6SG8xtkfwvF.Wtjd/uPpEwQMScX6Z4UBg1kzkaBK1ou2sr.o2'
  },
  {
    username: 'xdawn',
    display_name: 'Anzie',
    group: 'ADMIN',
    email: 'foo@example.com',
    password_digest: '$2a$10$O4j5wxARl/86reJbSNOWue0dZEhUC.dgtDAoYwseSCrMlwGm.bVtq'
  },
  {
    username: 'shrimp',
    display_name: 'Shrimp',
    group: 'ADMIN',
    email: 'bar@example.com',
    password_digest: '$2a$10$O4j5wxARl/86reJbSNOWue0dZEhUC.dgtDAoYwseSCrMlwGm.bVtq'
  }
]

devs.each do |dev|
  puts "creating dev: #{dev[:username]}"
  User.create(dev)
end

file = File.read(Rails.root.join('lib', 'assets', 'load_attacks.json'))
attacks = JSON.parse(file)

attacks.each do |attack|
  puts "loading attack: #{attack['attack_code']} #{attack['text']}"
  a = Attack.new(attack)
  a.save
end