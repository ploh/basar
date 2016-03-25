require 'rails_helper'

RSpec.describe "animals/index", type: :view do
  before(:each) do
    assign(:animals, [
      Animal.create!(
        :email => "Email",
        :role => 1
      ),
      Animal.create!(
        :email => "Email",
        :role => 1
      )
    ])
  end

  it "renders a list of animals" do
    render
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
