require 'rails_helper'

RSpec.describe "frontend/index.html.erb", type: :view do
  it 'has div#app for frontend' do
    render
    expect(rendered).to match('<div id="app"></div>')
  end
end
