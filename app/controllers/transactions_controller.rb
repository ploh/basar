class TransactionsController < ApplicationController
  load_and_authorize_resource

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

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction was successfully created.'
    else
      render action: 'new'
    end
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

  private

  # Only allow a trusted parameter "white list" through.
  def transaction_params
    result = params.require(:transaction).permit(items_attributes: [:seller_code, :price])
    result["items_attributes"].delete_if do |id, values|
      values["seller_code"].blank? && values["price"].blank?
    end
    result["items_attributes"].each do |id, values|
      values["price"].gsub!(",", ".") if values["price"]
    end
    result
  end
end
