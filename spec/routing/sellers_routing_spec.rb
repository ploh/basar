require "spec_helper"

describe SellersController do
  describe "routing" do

    it "routes to #index" do
      get("/sellers").should route_to("sellers#index")
    end

    it "routes to #new" do
      get("/sellers/new").should route_to("sellers#new")
    end

    it "routes to #show" do
      get("/sellers/1").should route_to("sellers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sellers/1/edit").should route_to("sellers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sellers").should route_to("sellers#create")
    end

    it "routes to #update" do
      put("/sellers/1").should route_to("sellers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sellers/1").should route_to("sellers#destroy", :id => "1")
    end

  end
end
