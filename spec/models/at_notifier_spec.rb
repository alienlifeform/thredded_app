require 'spec_helper'

describe AtNotifier, '#at_notifiable_members' do
  before do
    sam  = create(:user, name: 'sam')
    @joel = create(:user, name: 'joel', email: 'joel@example.com')
    @john = create(:user, name: 'john', email: 'john@example.com')
    @post = create(:post, user: sam, content: 'hey @joel and @john. - @sam')
    @joel.member_of @post.messageboard
    @john.member_of @post.messageboard
    sam.member_of @post.messageboard
  end

  it 'returns 2 users mentioned, not including post author' do
    notifier = AtNotifier.new(@post)
    at_notifiable_members = notifier.at_notifiable_members

    at_notifiable_members.should have(2).items
    at_notifiable_members.should include @joel
    at_notifiable_members.should include @john
  end

  it 'does not return any users already emailed about this post' do
    prev_notifications = create(:post_notification, post: @post,
      email: 'joel@example.com')
    notifier = AtNotifier.new(@post)

    notifier.at_notifiable_members.should have(1).item
    notifier.at_notifiable_members.should include @john
  end

  it 'does not return users not included in a private topic' do
    @post.topic = create(:private_topic, user: @post.user,
      last_user: @post.user, messageboard: @post.messageboard, users: [@joel])
    notifier = AtNotifier.new(@post)

    notifier.at_notifiable_members.should have(1).item
    notifier.at_notifiable_members.should include @joel
  end

  it 'does not return users that set their preference to "no @ notifications"' do
    create(:preference, notify_on_mention: false, user: @joel, messageboard: @post.messageboard)
    notifier = AtNotifier.new(@post)
    at_notifiable_members = notifier.at_notifiable_members

    at_notifiable_members.should have(1).items
    at_notifiable_members.should include @john
    at_notifiable_members.should_not include @joel
  end
end

describe AtNotifier, '#notifications_for_at_users' do
  before do
    sam  = create(:user, name: 'sam')
    @joel = create(:user, name: 'joel', email: 'joel@example.com')
    @john = create(:user, name: 'john', email: 'john@example.com')
    @post = create_post_by(sam)
    @joel.member_of @post.messageboard
    @john.member_of @post.messageboard
    sam.member_of @post.messageboard
  end

  it 'does not notify any users already emailed about this post' do
    notifier = AtNotifier.new(@post)
    notifier.notifications_for_at_users
    notified_emails = @post.post_notifications.map(&:email)

    notified_emails.should have(2).items
    notified_emails.should include('joel@example.com')
    notified_emails.should include('john@example.com')
  end

  def create_post_by(user)
    site = create(:site)
    messageboard = create(:messageboard, site: site)
    create(:post, user: user,
      content: 'hi @joel and @john. @sam', messageboard: messageboard)
  end
end
