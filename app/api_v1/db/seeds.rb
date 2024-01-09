# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data to avoid duplicates when re-seeding
Post.delete_all

# Creating seed data for posts
Post.create([
              { title: 'Ruby on Rails: The Magic Behind the Scenes', content: 'Rails is a powerful framework that makes it easier to develop web applications...' },
              { title: 'Understanding the React Lifecycle', content: 'React components go through a lifecycle that enables you to perform specific actions at certain times...' },
              { title: 'Demystifying C++ Pointers', content: 'Pointers in C++ are often seen as complex, but they are a powerful tool...' },
              { title: 'JavaScript Async/Await: A Deep Dive', content: 'Async/Await in JavaScript simplifies working with asynchronous functions...' },
              { title: 'PostgreSQL vs MySQL: A Comparative Study', content: 'Choosing the right database is crucial for your application, and often it comes down to PostgreSQL and MySQL...' }
            ])

puts "Seed data created: #{Post.count} posts available."
