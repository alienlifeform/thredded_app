class UsersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :thredded_abilities

  def show
    @user = User.where('lower(name) = ?', params[:id].downcase).first

    if @user.nil?
      error = "No user exists named #{params[:id]}"
      redirect_to root_path, flash: { error: error }
    else
      @recent_topics = @user.thredded_topics.recent
    end
  end

  def index
    @users = messageboard.users.order('lower(name)')
  end

  def thredded_abilities
    @thredded_abilities ||= Thredded::Ability.new(current_user)
  end
end
