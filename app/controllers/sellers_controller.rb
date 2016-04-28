class SellersController < ApplicationController
  load_and_authorize_resource

  before_action :load_tasks, except: :destroy

  # GET /sellers
  def index
    @sellers = Seller.list
  end

  def revenue
    @sellers = Seller.list true, true
    respond_to do |format|
      format.html
      format.csv { render text: view_context.revenues_csv( @sellers ) }
    end
  end

  # GET /sellers/new
#  def new
#    @seller = Seller.new
#    prepare_activities
#  end

  # GET /sellers/1/edit
  def edit
    prepare_activities
  end

  # POST /sellers
#  def create
#    @seller = Seller.new(seller_params)

#    if @seller.save
#      redirect_to sellers_path, notice: 'Seller was successfully created.'
#    else
#      js :new
#      render action: 'new'
#    end
#  end

  # PATCH/PUT /sellers/1
  def update
    prepare_activities
    if @seller.update(seller_params)
      unless @seller.warnings.empty?
        if flash[:warning]
          flash[:warning] << "\n"
        else
          flash[:warning] = ""
        end
        flash[:warning] << @seller.warnings.join("\n")
      end
#      puts @seller.to_yaml
#      puts @seller.activities.to_yaml
      redirect_to edit_seller_path(@seller), notice: 'Erfolgreich gespeichert'
    else
      js :edit
      render action: 'edit'
    end
  end

  # DELETE /sellers/1
#  def destroy
#    @seller.destroy
#    redirect_to sellers_url, notice: 'Seller was successfully destroyed.'
#  end

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

  def prepare_activities
    @seller.fill_activities
    @seller.correct_must_d_activities
  end

  def load_tasks
    @tasks = Task.list
  end

  # Only allow a trusted parameter "white list" through.
  def seller_params
    # @@@ can this be done in a cleaner way?
    raise if params["seller"]["activities_attributes"].any? do |num, attr|
      p num, attr, attr["me"], ""
      (attr["me"] || attr["helper"]) &&
        @tasks.any? {|task| task.id == attr["task_id"].to_i && task.must_d}
    end

    # @@@ avoid this mean hack and properly use virtual attributes (me() and helper()) in seller model
    #     problem: the model does not recognize that it has to be updated
    #     if you force it to with attribute_will_change!, it still uses the old value
    # s. http://stackoverflow.com/questions/23958170/understanding-attribute-will-change-method
    #    http://api.rubyonrails.org/v4.0.1/classes/ActiveRecord/NestedAttributes/ClassMethods.html
    #    http://railscasts.com/episodes/167-more-on-virtual-attributes?view=asciicast
    #    http://stackoverflow.com/questions/30914780/virtual-attribute-in-rails-4
    params["seller"]["activities_attributes"].each do |num, attr|
      attr["planned_count"] = (attr["me"] == "1" ? 1 : 0) + (attr["helper"] == "1" ? 1 : 0)
      attr.delete "me"
      attr.delete "helper"
    end
    # @@@ should be: can? :edit, ActualActivities (s. https://gist.github.com/alindeman/1903397)
    if current_user.seller?
      params.require(:seller).permit( #:name,
                                      #:number,
                                      #:initials,
                                      #:rate_in_percent,
                                      activities_attributes: [:planned_count, :task_id, :id] )
    else
      params.require(:seller).permit( #:name,
                                      #:number,
                                      #:initials,
                                      #:rate_in_percent,
                                      activities_attributes: [:actual_count, :planned_count, :task_id, :id] )
    end
  end
end
