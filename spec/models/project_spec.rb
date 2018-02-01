require 'rails_helper'

RSpec.describe Project, type: :model do
  # Association test
  it { should belong_to(:course) }
  it { should have_and_belong_to_many(:users) }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:course_id) }

  it "can have many users" do
    subject.title = "Anything"
    subject.course_id = create(:course).id
    subject.save!
    subject.users << create(:user)
    subject.users << create(:user)
    subject.save!
    expect(subject.users.size).to eq(2)
  end

  it "project cannot be created, if course enrollment is closed" do
    course = create(:course)
    subject.title = "Anything"
    subject.course_id = course.id
    subject.save!
    course.update!(:allow_enrollment => false)
    expect(subject).not_to be_valid
  end

  it "sprint planning can be completed" do
    course = create(:course)
    sprint = create(:sprint, course_id: course.id)
    project = create(:project, course_id: course.id)
    project_sprint_relation = project.sprint_plannings.build(sprint_id: sprint.id, planned: false)
    project_sprint_relation.update_attribute(:planned, true)
    expect(project_sprint_relation.planned).to be(true)
  end

end