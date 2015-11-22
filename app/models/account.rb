class Account < ActiveRecord::Base
  validates :name, presence: true

  has_many :people
  has_many :memberships
  has_many :users, through: :memberships
end
