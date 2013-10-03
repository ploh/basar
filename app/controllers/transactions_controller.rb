class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.order("created_at desc").limit(50)
  end

  def index_all
    @transactions = Transaction.order("created_at desc")
    render "index"
  end

  # GET /transactions/1
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
    redirect_to @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction was successfully created.'
    else
      render action: 'new'
    end
#     @transaction.save
#     redirect_to @transaction, notice: 'Transaction was successfully created.'
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: 'Transaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  # for AJAX validation requests
  def validate
    @transaction = Transaction.new(transaction_params(false))
    @transaction.items.each {|item| item.price ||= 999}
    @transaction.valid?
    @transaction.items.each {|item| item.price = nil if item.price == 999}
    render partial: 'form'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params(with_item_id = true)
      allowed_item_attributes = (with_item_id ? [:id] : []) + [:seller_code, :price, :transaction_id]
      result = params.require(:transaction).permit(:items_attributes => allowed_item_attributes)
      result["items_attributes"].delete_if do |id, values|
        values["seller_code"].blank? && values["price"].blank?
      end
      result["items_attributes"].each do |id, values|
        values["price"] = values["price"].gsub(",", ".") if values["price"]
      end
      result
    end
end
