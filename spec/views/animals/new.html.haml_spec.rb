require 'rails_helper'

RSpec.describe "animals/new", type: :view do
  before(:each) do
    assign(:animal, Animal.new(
      :email => "MyString",
      :role => 1
    ))
  end

  it "renders new animal form" do
    render

    assert_select "form[action=?][method=?]", animals_path, "post" do

      assert_select "input#animal_email[name=?]", "animal[email]"

      assert_select "input#animal_role[name=?]", "animal[role]"
    end
  end
end
