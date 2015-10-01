class SellersController < ApplicationController
  load_and_authorize_resource

  before_action :load_tasks, except: :destroy

  # GET /sellers
  def index
    @sellers = Seller.order("number")
  end

  def revenue
    @sellers = Seller.order("number")
    respond_to do |format|
      format.html
      format.csv { render text: view_context.revenues_csv( @sellers ) }
    end
  end

  # GET /sellers/new
  def new
    @seller = Seller.new
    fill_activities
  end

  # GET /sellers/1/edit
  def edit
    fill_activities
  end

  # POST /sellers
  def create
    @seller = Seller.new(seller_params)

    if @seller.save
      redirect_to sellers_path, notice: 'Seller was successfully created.'
    else
      js :new
      render action: 'new'
    end
  end

  # PATCH/PUT /sellers/1
  def update
    if @seller.update(seller_params)
      redirect_to edit_seller_path(@seller), notice: 'Seller was successfully updated.'
    else
      js :edit
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

  def load_tasks
    @tasks = Task.all
  end

  def fill_activities
    @tasks.each do |task|
      @seller.activities.build task: task unless @seller.activities.exists? task: task
    end
  end

  # Only allow a trusted parameter "white list" through.
  def seller_params
    params.require(:seller).permit( :name,
                                    :number,
                                    :initials,
                                    :rate_in_percent,
                                    activities_attributes: [:planned_count, :actual_count, :task_id, :id] )
  end
end
