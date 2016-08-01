require 'random_data'

#Create Posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
  )
end

posts = Post.all

#Create Comments

100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

p = Post.find_or_create_by(title: "unique title", body: "unique body")
Comment.find_or_create_by(body: "this is a unique comment", post: p)


puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
