require 'spec_helper'

describe BrowsingHistory, '#last_read_post' do
  before do
    Post.paginates_per 2
  end

  it 'returns the first post for a new unread topic' do
    history = BrowsingHistory.new(topic)

    expect(history.post).to eq topic.posts.first
  end

  it 'delegates to the post on persisted model for a previously read topic' do
    previously_read!(topic)
    history = BrowsingHistory.new(topic)

    expect(history.post).to eq topic.posts.last
  end

  def topic
    create(:topic)
  end

  def previously_read!(topic)
    # create(:...)
  end
end

describe BrowsingHistory, '#page' do
  it 'delegates to persisted model' do

  end
end

describe BrowsingHistory, 'read?' do
  it 'is true when a topic has more posts than the user has read' do

  end

  it 'is false when there are the same num of posts as the user has read' do

  end
end
