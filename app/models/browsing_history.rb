class BrowsingHistory
  def initialize(topic, user, page)
    @topic = topic
    @user = user
    @page = page
    @read_history = UserTopicRead.where(user: user, topic: topic).first || NullTopicRead.new
  end

  def last_read_post

  end

  def read?

  end

  def unread?
    !read?
  end

  def page

  end

  private

  attr_reader :topic, :user, :read_history
end
