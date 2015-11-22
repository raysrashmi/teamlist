require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { should validate_presence_of(:user) }
  it "validates uniqueness of user" do
    create(:membership)
    should validate_uniqueness_of(:user).scoped_to(:account_id)
  end

  it { should belong_to(:account) }
  it { should belong_to(:user) }
end
