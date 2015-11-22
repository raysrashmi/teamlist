class User < ActiveRecord::Base
  include Clearance::User

  has_many :memberships
  has_many :accounts, through: :memberships
end
