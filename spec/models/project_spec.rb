require 'rails_helper'

RSpec.describe Project, type: :model do
  # Association test
  it { should belong_to(:course) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:course_id) }
end