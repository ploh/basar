class TransactionsController < ApplicationController
  load_and_authorize_resource

  # GET /transactions
  def index
    filtered_list = Transaction
    filtered_list = filtered_list.where(user: current_user) if current_user
    filtered_list = filtered_list.where(client_key: @client_key) if @client_key
    @transactions = filtered_list.order("created_at desc").limit(20)
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
    @transaction.items.build
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    @transaction.client_key = @client_key

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction was successfully created.'
    else
      js :new
      render action: 'new'
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
