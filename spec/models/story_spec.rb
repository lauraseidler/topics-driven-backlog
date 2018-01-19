require 'rails_helper'

RSpec.describe Story, type: :model do
  # Association test
  it { should have_many(:tasks).dependent(:destroy) }
  it { should belong_to(:project) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:project_id) }

  it "should get a default status on save" do
    course = create(:course)
    project = create(:project, course_id: course.id)
    subject = create(:story, project_id: project.id)
    subject.status = nil
    expect(subject).to be_valid
    subject.save
    expect(subject.status).to be(Story.statuses[:open])
  end

  it "should get a default project_position on save" do
    course = create(:course)
    project = create(:project, course_id: course.id)
    subject = create(:story, project_id: project.id)
    expect(subject).to be_valid
    subject.save
    project_pos_record = ProjectPosition.find_by(story_id: subject.id, project_id: project.id)
    expect(project_pos_record).not_to be_nil
    expect(project_pos_record.position).to be_an_instance_of(Integer)
  end

  it "should get a default sprint_position if sprint was defined on save" do
    course = create(:course)
    project = create(:project, course_id: course.id)
    sprint = create(
        :sprint,
        course_id: course.id,
        start_date: Date.yesterday,
        end_date: Date.tomorrow
    )
    subject = create(:story, project_id: project.id, sprint_id: sprint.id)
    expect(subject).to be_valid
    subject.save
    sprint_pos_record = SprintPosition.find_by(story_id: subject.id, sprint_id: sprint.id)
    expect(sprint_pos_record).not_to be_nil
    expect(sprint_pos_record.position).to be_an_instance_of(Integer)
  end

  it "is not valid if new assigned Sprint is finished" do
    course = create(:course)
    project = create(:project, course_id: course.id)
    subject = create(:story, project_id: project.id)
    finished_sprint = create(
        :sprint,
        course_id: course.id,
        start_date: Date.new(2001,2,3),
        end_date: Date.new(2001,9,3)
    )
    subject.sprint_id = finished_sprint.id
    expect(subject).not_to be_valid
  end

  it "is valid if new assigned Sprint is not finished" do
    course = create(:course)
    project = create(:project, course_id: course.id)
    subject = create(:story, project_id: project.id)
    subject.save
    sprint = create(
        :sprint,
        course_id: create(:course).id,
        start_date: Date.yesterday,
        end_date: Date.tomorrow
    )
    subject.sprint_id = sprint.id
    subject.save
    expect(subject).to be_valid
  end

end