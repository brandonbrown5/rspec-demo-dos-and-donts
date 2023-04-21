class Post < ApplicationRecord
  belongs_to :user

  def other_users_can_see
    user.is_enabled && is_published
  end

  def self.are_there_important_posts?
    self.where(is_important: true).any?
  end
end
