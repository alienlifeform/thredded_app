class MessageboardsController < ApplicationController
  load_and_authorize_resource
  before_filter :messageboard, :only => :show
  layout 'application'
  
  def index
    redirect_to new_user_session_url(:host => site.cached_domain) unless can? :read, site
  end

  def show
    unless site.present? and can? :read, messageboard
      flash[:error] = "You are not authorized access to this messageboard." 
      redirect_to root_url(:host => site.cached_domain)
      return 
    end
    @topics = messageboard.topics
    @messageboards = site.messageboards
  end

  # ======================================

  def default_home
    # if %w{test development}.include?( Rails.env )
    if %w{test}.include?( Rails.env )
      site_messageboards_path(THREDDED[:default_site]) 
    else
      root_url(:host => THREDDED[:default_domain])
    end
  end

end
