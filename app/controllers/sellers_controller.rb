class SellersController < ApplicationController
  load_and_authorize_resource

  before_action :load_tasks, except: :destroy

  # GET /sellers
  def index
    @sellers = Seller.list
    respond_to do |format|
      format.html
      format.csv { render text: view_context.list_csv( @sellers ) }
    end
  end

  def revenue
    # @@@ forbidden for assistants: they can only "read" sellers, not "revenue" them
    @sellers = Seller.list true, true
    respond_to do |format|
      format.html
      format.csv { render text: view_context.revenues_csv( @sellers ) }
    end
  end

  # GET /sellers/cake
  def cake_form
    @user = current_user
  end

  # PUT /sellers/cake
  def cake
    @user = current_user
    @user.assign_attributes cake_params

    if @user.save
      redirect_to sellers_cake_path, notice: 'Erfolgreich gespeichert'
    else
      js :apply
      render action: 'cake_form'
    end
  end

  # GET /sellers/help
  def help_form
    @user = current_user
  end

  # PUT /sellers/help
  def help
    @user = current_user
    @user.assign_attributes help_params

    if @user.save
      redirect_to sellers_help_path, notice: 'Erfolgreich gespeichert'
    else
      js :apply
      render action: 'help_form'
    end
  end

  # GET /sellers/apply
  def apply_form
    @user = current_user
  end

  # PUT /sellers/apply
  def apply
    @user = current_user
    @user.assign_attributes apply_params

    success = true
    unless params[:terms]
      flash[:error] = 'Sie müssen die Verkaufsbedingungen akzeptieren'
      success = false
    end

    if success
      if Setting.drawn_applicants
        ActiveRecord::Base.transaction do
          unless @user.save
            success = false
            raise ActiveRecord::Rollback
          end

          @seller = Seller.new(user: @user, model: Seller.models_by_id[@user.wish_a])
          @seller.number = @user.old_number || Seller.generate_number
          @seller.initials = @user.old_initials || @user.initials
          @seller.valid?
          unless @seller.errors.empty?
            Rails.logger.warn "Could not save seller #{@seller.inspect} because of errors: #{@seller.errors.full_messages}"
            Rails.logger.info "Generating new number for #{@seller.inspect}..."
            @seller.number = Seller.generate_number
            @seller.initials = @user.initials
          end
          Rails.logger.info "Saving new seller #{@seller.inspect}..."
          unless @seller.save
            success = false
            @user.seller = nil
            raise ActiveRecord::Rollback
          end
        end
      else
        if @user.save
          SellerMailer.apply(@user).deliver_later
        else
          success = false
        end
      end
    end

    if success
      if Setting.drawn_applicants
        redirect_to edit_seller_path(@seller), notice: 'Erfolgreich gespeichert'
      else
        redirect_to sellers_apply_path, notice: 'Erfolgreich gespeichert'
      end
    else
      js :apply
      render action: 'apply_form'
    end
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
    @seller.current_user = current_user

    if @seller.save
      unless @seller.warnings.empty?
        if flash[:warning]
          flash[:warning] << "\n"
        else
          flash[:warning] = ""
        end
        flash[:warning] << @seller.warnings.join("\n")
      end
      redirect_to edit_seller_path(@seller), notice: 'Erfolgreich gespeichert'
    else
      js :new
      render action: 'new'
    end
  end

  # PATCH/PUT /sellers/1
  def update
    @seller.current_user = current_user
    if @seller.update(seller_params)
      unless @seller.warnings.empty?
        if flash[:warning]
          flash[:warning] << "\n"
        else
          flash[:warning] = ""
        end
        flash[:warning] << @seller.warnings.join("\n")
      end
      redirect_to edit_seller_path(@seller), notice: 'Erfolgreich gespeichert'
    else
      js :edit
      render action: 'edit'
    end
  end

  # DELETE /sellers/1
  def destroy
    @seller.current_user = current_user
    @seller.destroy
    if can? :read, User
      redirect_to sellers_url, notice: 'Seller was successfully destroyed.'
    else
      redirect_to pages_selling_url, notice: 'Erfolgreich abgemeldet.'
    end
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
    @tasks = Task.list
  end

  # Only allow a trusted parameter "white list" through.
  def seller_params
    if action_name == 'create'
      # @@@ should be: can? :edit, ActualActivities (s. https://gist.github.com/alindeman/1903397)
      if current_user.seller?
        params.require(:seller).permit()
      else
        params.require(:seller).permit( :number,
                                        :initials,
                                        :user_id,
                                        :model )
      end
    else
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
        params.require(:seller).permit( activities_attributes: [:planned_count, :task_id, :id] )
      else
        params.require(:seller).permit( :number,
                                        :initials,
                                        :user_id,
                                        :model,
                                        activities_attributes: [:actual_count, :planned_count, :task_id, :id] )
      end
    end
  end

  def apply_params
    # Only allow a trusted parameter "white list" through.
    params.require(:user).permit(:wish_a, :wish_b, :wish_c)
  end

  def cake_params
    # Only allow a trusted parameter "white list" through.
    params.require(:user).permit(:cake)
  end

  def help_params
    # Only allow a trusted parameter "white list" through.
    params.require(:user).permit(:help)
  end
end
