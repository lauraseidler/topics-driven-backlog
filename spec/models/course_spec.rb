require 'rails_helper'

RSpec.describe Course, type: :model do

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

end