class User < ApplicationRecord
  has_many :memberships
  has_many :projects, through: :memberships

  validates :email, presence: true, uniqueness: true
end
