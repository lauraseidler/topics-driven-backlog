class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :project

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2, :canceled => 3}
  end

  before_validation :update_sprint_position, on: :update
  before_validation :set_status
  before_create :set_identifier, on: :create
  after_commit :create_project_position, on: :create
  after_commit :create_sprint_position, on: :create

  validates_presence_of :title, :status, :project_id

  private

  def set_identifier
    if self.identifier.nil?
      project = Project.find_by!(id: project_id)
      last_story = project.stories.order('created_at').last
      if last_story.nil?
        self.identifier = 'S-1'
      else
        self.identifier = last_story.identifier.next
      end
    end
  end

  def set_status
    if self.status.blank?
      self.status = Story.statuses[:open]
    end
  end

  def create_project_position
    project_position = ProjectPosition.create(
        :project_id => self.project_id, :story_id => self.id
    )
    project_position.set_list_position(0)
    project_position.save!
    project_position.move_to_bottom
  end

  def update_sprint_position
    unless sprint_id_in_database.present?
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
      sprint_position.move_to_bottom
    end
  end

end
