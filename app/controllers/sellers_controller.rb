class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]

  # GET /sellers
  def index
    @sellers = Seller.order("number")
  end

  # GET /sellers/1
  def show
  end

  # GET /sellers/new
  def new
    @seller = Seller.new
  end

  # GET /sellers/1/edit
  def edit
  end

  # POST /sellers
  def create
    @seller = Seller.new(seller_params)

    if @seller.save
      redirect_to sellers_path, notice: 'Seller was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /sellers/1
  def update
    if @seller.update(seller_params)
      redirect_to sellers_path, notice: 'Seller was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /sellers/1
  def destroy
    @seller.destroy
    redirect_to sellers_url, notice: 'Seller was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def seller_params
      params.require(:seller).permit(:name, :number, :initials, :rate_in_percent)
    end
end
