include Sprig::Helpers

Sprig.configure do | config|
  config.shared_directory = 'shared'
end

sprig [User, Post, Comment, Post::Follow]
