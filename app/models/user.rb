class User < ApplicationRecord
  has_many :instructions
  has_many :courses, :through => :instructions
  has_and_belongs_to_many :projects

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
