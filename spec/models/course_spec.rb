require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association test
  it { should have_many(:sprints).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:title) }

  it "is valid with semester type and date" do
    subject.title = "Anything"
    subject.semester_type = 'W'
    subject.semester_year = DateTime.now.year
    expect(subject).to be_valid
  end

  it "is not valid without proper semester_year" do
    subject.title = "Anything"
    subject.semester_type = 'W'
    subject.semester_year = 100
    expect(subject).not_to be_valid
  end

  it "is not valid without proper semester_type" do
    subject.title = "Anything"
    subject.semester_type = 'Q'
    subject.semester_year = DateTime.now.year
    expect(subject).not_to be_valid
  end

  it "can have many users as instructors" do
    subject = create(:course)
    subject.instructions.build(user_id: create(:user).id, initial_instructor: true)
    subject.instructions.build(user_id: create(:user).id, initial_instructor: false)
    subject.save!
    expect(subject.instructions.size).to eq(2)
  end

  it "instructors can be removed" do
    subject = create(:course)
    second_instructor = create(:user)
    subject.instructions.build(user_id: create(:user).id, initial_instructor: true)
    subject.instructions.build(user_id: second_instructor.id, initial_instructor: false)
    subject.save!
    subject.users.delete(second_instructor)

    expect(subject.instructions.size).to eq(1)
  end

end