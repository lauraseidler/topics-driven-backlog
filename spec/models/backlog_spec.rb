require 'rails_helper'

RSpec.describe Backlog, type: :model do
  # Association test
  it { should have_many(:stories) }
end