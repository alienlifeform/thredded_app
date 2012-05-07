class TopicsController < ApplicationController
  before_filter :pad_params,  :only => [:create, :update]
  before_filter :pad_post,    :only => :create
  before_filter :pad_topic,   :only => :create

  def index
    unless site.present? and can? :read, messageboard
      flash[:error] = 'You are not authorized access to this messageboard.'
      redirect_to default_home and return
    end
    @messageboards = site.messageboards
    @sticky, @topics = current_sticky_and_topics
    redirect_if_no_search_results_for @topics
  end

  def new
    @topic = messageboard.topics.build
    unless can? :create, @topic
      flash[:error] = "Sorry, you are not authorized to post on this messageboard."
      redirect_to messageboard_topics_path(messageboard)
    end
    @topic.type = "PrivateTopic" if params[:type] == "private"
    @topic.posts.build
  end

  def create
    @topic = klass.create(params[:topic])
    redirect_to messageboard_topics_path(messageboard)
  end

  def edit
    authorize! :update, topic
  end
 
  def update
    topic.update_attributes(params[:topic])
    redirect_to messageboard_topic_posts_path(messageboard, topic)
  end

  # ======================================

  private

  def current_sticky_and_topics
    if params[:q].present?
      @sticky = []
      @topics = Topic.full_text_search(params[:q], messageboard.id) 
    else
      if params[:page].nil? || params[:page] == '1'
        @sticky = Topic.stuck.where(messageboard_id: messageboard.id).order('id DESC')
      else
        @sticky = []
      end
      @topics = Topic.unstuck.where(messageboard_id: messageboard.id).order('updated_at DESC').page(params[:page]).per(30)
    end
    [@sticky, @topics]
  end

  def redirect_if_no_search_results_for(topics)
    if params[:q].present? && topics.length == 0
      redirect_to messageboard_topics_path(messageboard), :flash => { :error => "No topics found for this search." } 
    end
  end

  def default_home
    root_url(:host => site.cached_domain)
  end


  def klass
    @klass ||= params[:topic][:type].present? ? params[:topic][:type].constantize : Topic
  end

  def pad_params
    params[:topic][:user] = current_user
    params[:topic][:last_user] = current_user
  end

  def pad_topic
    params[:topic][:user_id] << current_user.id.to_s if current_user and params[:topic][:user_id].present?
    params[:topic][:last_user] = current_user
    params[:topic][:messageboard] = messageboard
  end

  def pad_post
    params[:topic][:posts_attributes]["0"][:messageboard] = messageboard
    params[:topic][:posts_attributes]["0"][:ip] = request.remote_ip
    params[:topic][:posts_attributes]["0"][:user] = current_user
  end

end
