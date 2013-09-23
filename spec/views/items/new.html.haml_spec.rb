require 'spec_helper'

describe "items/new" do
  before(:each) do
    assign(:item, stub_model(Item,
      :seller => nil,
      :price => "9.99"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", items_path, "post" do
      assert_select "input#item_seller[name=?]", "item[seller]"
      assert_select "input#item_price[name=?]", "item[price]"
    end
  end
end
