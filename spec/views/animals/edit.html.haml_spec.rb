require 'rails_helper'

RSpec.describe "animals/edit", type: :view do
  before(:each) do
    @animal = assign(:animal, Animal.create!(
      :email => "MyString",
      :role => 1
    ))
  end

  it "renders the edit animal form" do
    render

    assert_select "form[action=?][method=?]", animal_path(@animal), "post" do

      assert_select "input#animal_email[name=?]", "animal[email]"

      assert_select "input#animal_role[name=?]", "animal[role]"
    end
  end
end
