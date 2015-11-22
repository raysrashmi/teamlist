require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it "validates uniqueness of email" do
    create(:person)
    should validate_uniqueness_of(:email).scoped_to(:account_id)
  end
  it { should validate_presence_of(:hired_on) }

  it { should belong_to(:account) }
end
