class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  skip_authorization_check

  def home
  end

  def about
  end

  def privacy
  end

  def terms
  end
end
