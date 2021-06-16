# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  is_public              :boolean
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'is valid when email is unique' do
      user1 = create(:user)
      user2 = create(:user)

      expect(user2.email).not_to be user1.email
      expect(user2.valid?).to be true
    end

    it 'is invalid if the email is taken' do
      create(:user)

      user = User.new
      user.email = 'adam@example.com'
      expect(user.valid?).to be false
    end

    it 'is invalid if the username is taken' do
      user1 = create(:user) # $create(:user)
      user2 = create(:user) # :request_id(:user)

      expect(user2.valid?).to be true
      user2.username = user1.username
      expect(user2.valid?).to be false
    end

    it "is invalid if user's first name is blank" do
      user = create(:user)
      expect(user.valid?).to be true

      user.first_name = ""
      expect(user.valid?).to be false

      user.first_name = nil
      expect(user.valid?).to be false
    end

    it "invalid if the email looks bogus" do
      user = create(:user)
      expect(user.valid?).to be true

      user.email = ""
      expect(user.valid?).to be false

      user.email = "foo.bar"
      expect(user.valid?).to be false

      user.email = "foo.bar#example.com"
      expect(user.valid?).to be false

      user.email = "fo.o.b.a.r@example.com"
      expect(user.valid?).to be true

      user.email = "foo+bar@example.com"
      expect(user.valid?).to be true

      user.email = "foo.bar@sub.example.co.nz"
      expect(user.valid?).to be true
    end
  end

  describe "#followings" do
    it "can list all of the user's followings" do
      user = create(:user)
      friend1 = create(:user)
      friend2 = create(:user)
      friend3 = create(:user)

      Bond.create(user: user, friend: friend1, state: Bond::FOLLOWING)
      Bond.create(user: user, friend: friend2, state: Bond::FOLLOWING)
      Bond.create(user: user, friend: friend3, state: Bond::REQUESTING)

      # Bond.create user: user,
      #             friend: friend1,
      #             state: Bond::FOLLOWING
      # Bond.create user: user,
      #             friend: friend2,
      #             state: Bond::FOLLOWING
      # Bond.create user: user,
      #             friend: friend2,
      #             state: Bond::REQUESTING

      expect(user.followings).to include(friend1, friend2)
      expect(user.follow_requests).to include(friend3)
    end
  end

  describe "#followers" do
    it "can list all of the user's followers" do
      user1 = create(:user)
      user2 = create(:user)
      fol1 = create(:user)
      fol2 = create(:user)
      fol3 = create(:user)
      fol4 = create(:user)

      Bond.create user: fol1, friend: user1, state: Bond::FOLLOWING
      Bond.create user: fol2, friend: user1, state: Bond::FOLLOWING
      Bond.create user: fol3, friend: user2, state: Bond::FOLLOWING
      Bond.create user: fol4, friend: user2, state: Bond::REQUESTING

      expect(user1.followers).to eq(([fol1, fol2]))
      expect(user2.followers).to eq(([fol3]))
    end
  end

  describe "#save" do
    it "capitalized the name correctly" do
      user = create(:user)

      user.first_name = "AdAM"
      user.last_name = "van der Berg"
      user.save

      expect(user.first_name).to eq "Adam"
      expect(user.last_name).to eq "van der Berg"
    end
  end
end
