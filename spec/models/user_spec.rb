require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#validations' do
    it 'tests model factory' do
      expect(user).to be_valid
    end

    it 'tests uid validation' do
      user1 = FactoryBot.build(:user, uid: user.uid)
      check_expected_validation_errors(user1, [:taken])
      user.uid = nil
      check_expected_validation_errors(user, [:blank])
      user.uid = ' '
      check_expected_validation_errors(user, [:blank])
      user.uid = SecureRandom.uuid[0..27]
      expect(user).to be_valid
      user.uid = SecureRandom.uuid[0..26]
      check_expected_validation_errors(user, [:wrong_length])
      user.uid = SecureRandom.uuid[0..28]
      check_expected_validation_errors(user, [:wrong_length])
    end

    it 'tests username validation' do
      user1 = FactoryBot.build(:user, username: user.username)
      check_expected_validation_errors(user1, [:taken])
      user.username = nil
      check_expected_validation_errors(user, [:blank])
      user.username = ' '
      check_expected_validation_errors(user, [:blank])
      user.username = 'x'
      expect(user).to be_valid
      user.username = SecureRandom.uuid[0..19]
      expect(user).to be_valid
      user.username = SecureRandom.uuid[0..20]
      check_expected_validation_errors(user, [:too_long])
    end

    it 'tests auth_role validation' do
      user.auth_role = nil
      check_expected_validation_errors(user, [:blank, :not_a_number])
      user.auth_role = -1
      check_expected_validation_errors(user, [:greater_than_or_equal_to])
      user.auth_role = 0
      expect(user).to be_valid
      user.auth_role = 1
      expect(user).to be_valid
      user.auth_role = 2
      check_expected_validation_errors(user, [:less_than_or_equal_to])
    end
  end
end

