class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :account_id }
  validates :hired_on, presence: true
  validates :account, presence: true

  belongs_to :account
end
