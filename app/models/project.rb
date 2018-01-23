class Project < ApplicationRecord
  belongs_to :course
  has_many :stories, dependent: :destroy
  has_and_belongs_to_many :users

  validates_presence_of :title, :course_id
  validates :title, uniqueness: { scope: :course_id }
end
