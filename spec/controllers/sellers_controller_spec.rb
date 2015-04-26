require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe SellersController do
  before(:each) { mock_sign_in :admin }

  # This should return the minimal set of attributes required to create a valid
  # Seller. As you add validations to Seller, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { initials: "AL", number: 1, name: "Anna", rate: 0.1, rate_in_percent: 10 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SellersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all sellers as @sellers" do
      seller = Seller.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:sellers)).to eq([seller])
    end
  end

  describe "GET new" do
    it "assigns a new seller as @seller" do
      get :new, {}, valid_session
      expect(assigns(:seller)).to be_a_new(Seller)
    end
  end

  describe "GET edit" do
    it "assigns the requested seller as @seller" do
      seller = Seller.create! valid_attributes
      get :edit, {:id => seller.to_param}, valid_session
      expect(assigns(:seller)).to eq(seller)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Seller" do
        expect {
          post :create, {:seller => valid_attributes}, valid_session
        }.to change(Seller, :count).by(1)
      end

      it "assigns a newly created seller as @seller" do
        post :create, {:seller => valid_attributes}, valid_session
        expect(assigns(:seller)).to be_a(Seller)
        expect(assigns(:seller)).to be_persisted
      end

      it "redirects to the sellers list" do
        post :create, {:seller => valid_attributes}, valid_session
        expect(response).to redirect_to(sellers_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved seller as @seller" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Seller).to receive(:save).and_return(false)
        post :create, {:seller => { "initials" => "invalid value" }}, valid_session
        expect(assigns(:seller)).to be_a_new(Seller)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Seller).to receive(:save).and_return(false)
        post :create, {:seller => { "initials" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested seller" do
        seller = Seller.create! valid_attributes
        # Assuming there are no other sellers in the database, this
        # specifies that the Seller created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        allow_any_instance_of(Seller).to receive(:update).with({ "name" => "MyString" })
        put :update, {:id => seller.to_param, :seller => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested seller as @seller" do
        seller = Seller.create! valid_attributes
        put :update, {:id => seller.to_param, :seller => valid_attributes}, valid_session
        expect(assigns(:seller)).to eq(seller)
      end

      it "redirects to the sellers list" do
        seller = Seller.create! valid_attributes
        put :update, {:id => seller.to_param, :seller => valid_attributes}, valid_session
        expect(response).to redirect_to(sellers_url)
      end
    end

    describe "with invalid params" do
      it "assigns the seller as @seller" do
        seller = Seller.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Seller).to receive(:save).and_return(false)
        put :update, {:id => seller.to_param, :seller => { "name" => "invalid value" }}, valid_session
        expect(assigns(:seller)).to eq(seller)
      end

      it "re-renders the 'edit' template" do
        seller = Seller.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Seller).to receive(:save).and_return(false)
        put :update, {:id => seller.to_param, :seller => { "name" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested seller" do
      seller = Seller.create! valid_attributes
      expect {
        delete :destroy, {:id => seller.to_param}, valid_session
      }.to change(Seller, :count).by(-1)
    end

    it "redirects to the sellers list" do
      seller = Seller.create! valid_attributes
      delete :destroy, {:id => seller.to_param}, valid_session
      expect(response).to redirect_to(sellers_url)
    end
  end

end
