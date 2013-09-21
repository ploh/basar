require 'spec_helper'

describe "sellers/edit" do
  before(:each) do
    @seller = assign(:seller, stub_model(Seller,
      :name => "MyString",
      :number => 1,
      :initials => "MyString",
      :rate => "9.99"
    ))
  end

  it "renders the edit seller form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", seller_path(@seller), "post" do
      assert_select "input#seller_name[name=?]", "seller[name]"
      assert_select "input#seller_number[name=?]", "seller[number]"
      assert_select "input#seller_initials[name=?]", "seller[initials]"
      assert_select "input#seller_rate[name=?]", "seller[rate]"
    end
  end
end
