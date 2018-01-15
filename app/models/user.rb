class User < ApplicationRecord
  has_many :memberships
  has_many :projects, through: :memberships

  has_secure_password

  validates_presence_of :name, :email, :password_digest
end
