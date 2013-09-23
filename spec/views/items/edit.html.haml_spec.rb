require 'spec_helper'

describe "items/edit" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :seller => nil,
      :price => "9.99"
    ))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", item_path(@item), "post" do
      assert_select "input#item_seller[name=?]", "item[seller]"
      assert_select "input#item_price[name=?]", "item[price]"
    end
  end
end
