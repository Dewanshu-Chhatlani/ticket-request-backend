user1 = User.create(first_name: 'Admin', email: 'admin@requestapp.com', password: 'admin', admin: true)
user2 = User.create(first_name: 'Test', email: 'test@requestapp.com', password: 'helloworld', admin: false)
user3 = User.create(first_name: 'Dewanshu', email: 'dewanshu@requestapp.com', password: 'helloworld', admin: false)


30.times do
  puts "Creating ticket for User1"
  user1.tickets.create(title: Faker::Job.title, description: Faker::GreekPhilosophers.quote)
end

30.times do
  puts "Creating ticket for User2"
  user2.tickets.create(title: Faker::Job.title, description: Faker::GreekPhilosophers.quote)
end

30.times do
  puts "Creating ticket for User3"
  user3.tickets.create(title: Faker::Job.title, description: Faker::GreekPhilosophers.quote)
end
