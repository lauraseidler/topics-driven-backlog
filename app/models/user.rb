class User < ApplicationRecord
  has_many :memberships
  has_many :projects, through: :memberships

  def self.roles
    { :student => 0, :instructor => 1 }
  end

  before_validation :set_role

  validates :email, presence: true, uniqueness: true

  private

  def set_role
    if self.role.blank?
      self.role = User.roles[:student]
    end
  end
end
