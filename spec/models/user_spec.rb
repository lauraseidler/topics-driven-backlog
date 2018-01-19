require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  it { should have_many(:projects) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }

  it "can have many projects" do
    subject = create(:user)
    subject.projects = create_list(:project, 10, course_id: create(:course).id )
    subject.save!
    expect(subject.projects.size).to eq(10)
  end
end
