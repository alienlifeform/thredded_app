class PostsController < ApplicationController
  include TopicsHelper
  load_and_authorize_resource only: [:index, :show]

  before_filter :ensure_topic_exists
  before_filter :pad_post, only: :create
  helper_method :messageboard, :topic
  layout 'application'

  def index
    authorize! :read, topic

    browsing_history = BrowsingHistory.new(topic, current_user, current_page)
    @post = topic.build_post(messageboard: messageboard, filter: current_user.post_filter)
    @posts = topic.posts.includes(user: :roles).page(current_page)

    browsing_history.update!
  end

  def create
    p = topic.posts.create(params[:post])
    redirect_to :back
  end

  def edit
    authorize! :edit, post
  end

  def update
    authorize! :update, post
    post.update_attributes(params[:post])
    redirect_to messageboard_topic_posts_path(messageboard, topic)
  end

  private

  def post
    post = topic.posts.find(params[:post_id])
    @post ||= post
  end

  def extra_data
    %Q{data-latest-read=#{@read_status.post_id || 0}} if @read_status
  end

  def current_page
    if params[:page]
      params[:page].to_i
    else
      1
    end
  end

  def pad_post
    params[:post][:ip] = request.remote_ip
    params[:post][:user] = current_user
    params[:post][:messageboard] = messageboard
  end

  def ensure_topic_exists
    if topic.blank?
      redirect_to default_home,
        flash: { error: 'This topic does not exist.' }
    end
  end
end
