class SellersController < ApplicationController
  load_and_authorize_resource

  # GET /sellers
  def index
    @sellers = Seller.order("number")
    @tasks = Task.all
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

#   # for AJAX validation requests
#   def validate_code
# #     params.each {|pa| p pa}
#
#     dummy_item = Item.create_dummy
#     dummy_item.seller_code = params[:seller_code]
#     dummy_transaction = Transaction.create_dummy
#     dummy_transaction.items << dummy_item
#     dummy_transaction.valid?
#     render json: { error_explanation: render_to_string( partial: 'transactions/error_explanation', locals: {messages: dummy_transaction.errors.full_messages}),
#                    seller_code: render_to_string( partial: 'items/seller_code', locals: {item: dummy_transaction.items.first}) }
#
#     # TODO: create fake item with dummy price and given seller code, then validate it and return partials for items price as well as error_explanation via json
# #     @transaction = Transaction.new(transaction_params(false))
# #     @transaction.items.each {|item| item.price ||= 999}
# #     @transaction.valid?
# #     @transaction.items.each {|item| item.price = nil if item.price == 999}
# #     render partial: 'form'
#   end

  private
    # Only allow a trusted parameter "white list" through.
    def seller_params
      params.require(:seller).permit(:name, :number, :initials, :rate_in_percent)
    end
end
