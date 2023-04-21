class User < ApplicationRecord
  has_many :posts

  validate :validate_username

  def self.any_users_admin?
    User.where(is_admin: true).any?
  end

  def can_delete_other_users_posts
    is_admin
  end

  def do_something
    true
  end

  def create_post
    self.posts.create!
  end

  def important_posts_exist
    Post.are_there_important_posts?
  end

  private

  def validate_username
    if username == 'bad_man'
      errors.add(:username, 'Invalid username')
    end
  end
end
