# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  postable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :bigint           not null
#  thread_id     :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_posts_on_postable  (postable_type,postable_id)
#
# Foreign Keys
#
#  fk_rails_...  (thread_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#save" do
    it "belong to a user" do
      user = User.create!(
        first_name: "Adam",
        email: "adam@example.com",
        username: "adam111"
      )

      post = Post.new(
        postable: Status.new(text: "wooooo")
      )

      post.save
      expect(post.persisted?).to be false

      post.user = user
      post.save
      expect(post.persisted?).to be true
    end
  end
end
