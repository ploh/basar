require 'rails_helper'

RSpec.describe "sellers/show" do
  before(:each) do
    @seller = assign(:seller, stub_model(Seller,
      :name => "Name",
      :number => 1,
      :initials => "Initials",
      :rate => 0.2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/Initials/)
    rendered.should match(/20\s*%/)
  end
end
