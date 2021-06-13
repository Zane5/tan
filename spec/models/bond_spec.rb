# == Schema Information
#
# Table name: bonds
#
#  id         :bigint           not null, primary key
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_bonds_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Bond, type: :model do
  describe "#valid?" do
    it "validates the state correctly" do
      friend = User.new
      user = User.new

      bond = Bond.new(
        user: user,
        friend: friend
      )

      expect(bond.valid?).to be false

      Bond::STATES.each do |state|
        bond.state = state
        expect(bond.valid?).to be true
      end
    end
  end
end
