class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all
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
  end

  # POST /transactions
  def create
#     debugger
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to transactions_path, notice: 'Transaction was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: 'Transaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      result = params.require(:transaction).permit(:items_attributes => [:id, :seller_code, :price, :transaction_id])
      result["items_attributes"].delete_if do |id, values|
        values["seller_code"].blank? && values["price"].blank?
      end
      result["items_attributes"].each do |id, values|
        values["price"] = values["price"].gsub(",",".") if values["price"]
      end
      result
    end
end
