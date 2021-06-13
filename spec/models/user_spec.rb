# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  first_name :string
#  is_public  :boolean
#  last_name  :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  def create_a_user(email: "#{SecureRandom.hex(4)}@example.com")
    User.create!(
      first_name: 'Adam',
      email: email,
      username: SecureRandom.hex(4)
    )
  end

  describe '#valid?' do
    it 'is valid when email is unique' do
      user1 = create_a_user
      user2 = create_a_user

      expect(user2.email).not_to be user1.email
      expect(user2.valid?).to be true
    end

    it 'is invalid if the email is taken' do
      create_a_user(email: 'adam@example.com')

      user = User.new
      user.email = 'adam@example.com'
      expect(user.valid?).to be false
    end

    it 'is invalid if the username is taken' do
      user1 = create_a_user # $create(:user)
      user2 = create_a_user # :request_id(:user)

      expect(user2.valid?).to be true
      user2.username = user1.username
      expect(user2.valid?).to be false
    end

    it "is invalid if user's first name is blank" do
      user = create_a_user
      expect(user.valid?).to be true

      user.first_name = ""
      expect(user.valid?).to be false

      user.first_name = nil
      expect(user.valid?).to be false
    end

    it "invalid if the email looks bogus" do
    end
  end
end
