require 'rails_helper'

RSpec.describe Course, type: :model do

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:start_date) }

  it "is valid end date comes after start date" do
    subject.title = "Anything"
    subject.start_date = DateTime.now
    subject.end_date = DateTime.now + 1.week
    expect(subject).to be_valid
  end

  it "is not valid start date comes after end date" do
    subject.title = "Anything"
    subject.start_date = DateTime.now + 1.week
    subject.end_date = DateTime.now
    expect(subject).not_to be_valid
  end

end