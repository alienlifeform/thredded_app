Given /^a messageboard named "([^"]*)" that I, "([^"]*)", am an? "([^"]*)" of$/ do |messageboard, name, role|
  if !u = User.where(:name => name).first
    u = Factory :user,
      :name                  => name,
      :email                 => "email@email.com",
      :password              => "password",
      :password_confirmation => "password"
  end
  m = Factory :messageboard,
    :name                  => messageboard,
    :security              => :public
  # u.member_of(m)
  u.send "#{role}_of".to_sym, m
end

When /^I enter a title "([^"]*)" with content "([^"]*)"$/ do |title, content|
  fill_in "Title", :with => title
  fill_in "Content", :with => content
end

When /^I submit the form$/ do
  click_button "Create New Topic"
end

Given /^a thread already exists on "([^"]*)"$/ do |board|
  m = Messageboard.where(:name => board).first
  t = m.topics.create(:last_user => "admin", :title => "thready thread", :user => "admin", :post_count => 1)
  t.posts.create(:content => "FIRST!", :user => "admin")
end

When /^I submit some drivel like "([^"]*)"$/ do |content|
  fill_in "post_content", :with => content
  click_button "Submit"
end

Given /^I create the following new topics:$/ do |topics_table|
  u = User.first
  m = Messageboard.first
  topics_table.hashes.each_with_index { |topic, i|
    # travel 10 seconds in the future so all new topics aren't at the same time
    Timecop.travel(Time.now.advance(:seconds => i*10))
    
    # create topics and posts
    t = m.topics.create(:last_user => u.name, :title => topic[:title], :messageboard => m, :user => u.name, :post_count => 1)
    t.posts.create(:content => topic[:content], :user => u.name)
  }
end

Then /^the topic listing should look like the following:$/ do |topics_table|
  topics_table.diff!(tableish('#content header, #content article','h1 a,.started_by a,.updated_by a,.post_count, div'))
end

Given /^another member named "([^"]*)" exists$/ do |name|
  u = User.create(:name                  => name,
                  :email                 => "#{name}@email.com",
                  :password              => "password",
                  :password_confirmation => "password")
end

When /^I enter a recipient named "([^"]*)", a title "([^"]*)" and content "([^"]*)"$/ do |username, title, content|
  fill_in "Usernames", :with => username
  And  %{I enter a title "#{title}" with content "#{content}"}
end

Given /^a private thread exists between "([^"]*)" and "([^"]*)" titled "([^"]*)"$/ do |user1, user2, title|
  @topic = Factory(:topic, :messageboard => Messageboard.first, :title => title, :user => user1)
  @user1 = Factory(:user, :name => user1)
  @user2 = Factory(:user, :name => user2)
  @topic.posts << Factory(:post, :user => user1)
  @topic.users = [@user1, @user2]
  @topic.save
end