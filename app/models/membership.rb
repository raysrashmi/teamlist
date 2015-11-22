class Membership < ActiveRecord::Base
  validates :account, presence: true
  validates :user, presence: true, uniqueness: { scope: :account_id }

  belongs_to :account
  belongs_to :user
end
