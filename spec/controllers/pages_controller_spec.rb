require 'rails_helper'

RSpec.describe PagesController, :type => :controller do

  describe "GET home" do
    it "returns http success" do
      mock_sign_in nil
      get :home
      expect(response).to have_http_status(:success)
    end
  end

end
