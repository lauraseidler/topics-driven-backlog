require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  it { should have_and_belong_to_many(:projects) }

  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it "can have many projects" do
    subject = create(:user)
    subject.projects = create_list(:project, 10, course_id: create(:course).id )
    subject.save!
    expect(subject.projects.size).to eq(10)
  end

  it "should get a default status on save" do
    subject = create(:user)
    expect(subject).to be_valid
    subject.role = nil
    subject.save
    expect(subject.role).to be(User.roles[:student])
  end

end
