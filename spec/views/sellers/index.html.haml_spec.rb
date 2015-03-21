require 'spec_helper'

RSpec.describe "sellers/index" do
  before(:each) do
    assign(:sellers, [
      stub_model(Seller,
        :name => "Name",
        :number => 1,
        :initials => "Initials",
        :rate => 0.2
      ),
      stub_model(Seller,
        :name => "Name",
        :number => 1,
        :initials => "Initials",
        :rate => 0.2
      )
    ])
  end

  it "renders a list of sellers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Initials".to_s, :count => 2
    assert_select "tr>td", :text => "20 %".to_s, :count => 2
  end
end
