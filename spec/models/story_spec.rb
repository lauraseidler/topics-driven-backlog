require 'rails_helper'

RSpec.describe Story, type: :model do
  # Association test
  it { should have_many(:tasks).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:title) }

  it "should get a default status on save" do
    subject = create(:story)
    subject.status = nil
    expect(subject).to be_valid
    subject.save
    expect(subject.status).to be(Story.statuses[:open])
  end

  it "is not valid if new assigned Sprint is finished" do
    subject = create(:story)
    finished_sprint = create(
        :sprint,
        course_id: create(:course).id,
        start_date: Date.new(2001,2,3),
        end_date: Date.new(2001,9,3)
    )
    subject.sprint_id = finished_sprint.id
    expect(subject).not_to be_valid
  end

  it "is valid if new assigned Sprint is not finished" do
    subject = create(:story, sprint_id: nil)
    subject.save
    expect(subject).to be_valid
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