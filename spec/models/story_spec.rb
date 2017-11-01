require 'rails_helper'

RSpec.describe Story, type: :model do
  # Association test
  it { should have_many(:tasks).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:title) }
end