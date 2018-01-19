class Project < ApplicationRecord
  belongs_to :course
  has_many :stories, dependent: :destroy
  has_many :memberships
  has_many :users, through: :memberships

  validates_presence_of :title, :course_id
  validates :title, uniqueness: { scope: :course_id }
end
