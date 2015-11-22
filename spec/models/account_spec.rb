require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:memberships) }
  it { should have_many(:users).through(:memberships) }
end
