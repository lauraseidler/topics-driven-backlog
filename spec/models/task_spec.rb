require 'rails_helper'

RSpec.describe Task, type: :model do
  # Association test
  it { should belong_to(:story) }
  # Validation tests
  it { should validate_presence_of(:title) }
end