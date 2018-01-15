class User < ApplicationRecord
  has_many :memberships
  has_many :projects, through: :memberships

  has_secure_password

  validates_presence_of :name, :password_digest
  validates :email, presence: true, uniqueness: true
end
