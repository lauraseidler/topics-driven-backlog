require 'rails_helper'

RSpec.describe Topic, type: :model do
  # Association test
  it { should belong_to(:course) }
  it { should have_and_belong_to_many(:sprints) }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:course_id) }

  it "is not valid when url is invalid" do
    subject.title = 'Anything'
    subject.course_id = create(:course).id
    subject.url = 'foo/bar'
    expect(subject).not_to be_valid
  end

  it "is valid when url is valid" do
    subject.title = 'Anything'
    subject.course_id = create(:course).id
    subject.url = Faker::Internet::url
    expect(subject).to be_valid
  end

  it "can have many sprints" do
    course = create(:course)
    subject = create(:topic, course_id: course.id)
    subject.sprints = create_list(:sprint, 3, course_id: course.id)
    subject.save!
    expect(subject.sprints.size).to eq(3)
  end

end
