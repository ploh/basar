require 'spec_helper'

describe "sellers/show" do
  before(:each) do
    @seller = assign(:seller, stub_model(Seller,
      :name => "Name",
      :number => 1,
      :initials => "Initials",
      :rate => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/Initials/)
    rendered.should match(/9.99/)
  end
end
