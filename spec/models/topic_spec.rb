require 'rails_helper'

RSpec.describe Topic, type: :model do
  # Association test
  it { should belong_to(:course) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:course_id) }

  it "is not valid when url is invalid" do
    subject.title = 'Anything'
    subject.course_id = create(:course).id
    subject.url = 'foo/bar'
    expect(subject).not_to be_valid
  end
end