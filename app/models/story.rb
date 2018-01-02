class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :project

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2, :canceled => 3}
  end

  after_save :set_identifier
  after_commit :create_project_position, on: :create
  after_commit :create_sprint_position, on: :create
  after_commit :update_sprint_position, on: :update
  before_validation :set_status

  validates_presence_of :title, :status, :project_id
  validate :can_be_edited

  private

  def set_identifier
    if self.identifier.blank?
      self.identifier = 'S-'+self.id.to_s
    end
  end

  def set_status
    if self.status.blank?
      self.status = Story.statuses[:open]
    end
  end

  def can_be_edited
    if sprint_id_was.present?
      old_sprint = Sprint.find_by!(id: sprint_id_was)
      is_sprint_finished(old_sprint)
    end

    if sprint_id.present?
      sprint = Sprint.find_by!(id: sprint_id)
      is_sprint_finished(sprint)
    end
  end

  def is_sprint_finished(sprint)
    if sprint.end_date < Date.today
      errors.add(:sprint_id, 'was finished and cannot be changed')
    end
  end

  def create_project_position
    project_position = ProjectPosition.create(
        :project_id => self.project_id, :story_id => self.id
    )
    project_position.set_list_position(0)
    project_position.save!
  end

  def update_sprint_position
    if !sprint_id_was.present?
      create_sprint_position
    end
  end

  def create_sprint_position
    if self.sprint_id.present?
      sprint_position = SprintPosition.create(
          :sprint_id => self.sprint_id, :story_id => self.id
      )
      sprint_position.set_list_position(0)
      sprint_position.save!
    end
  end

end
