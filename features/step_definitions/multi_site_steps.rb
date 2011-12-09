Given /^the default "([^"]*)" website domain is "([^"]*)"$/ do |permission, website|
  THREDDED[:default_domain] = website
  THREDDED[:default_site]   = website.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  @site = Factory(:site, :cname_alias => website, :permission => permission)
end

Given /^I visit "([^"]*)"$/ do |domain|
  slug = domain.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  @site = Site.exists?(:cached_domain => domain) ? Site.find_by_cached_domain(domain) : Site.find_by_subdomain(slug)
  visit root_url(:host => @site.cached_domain)
end

Given /^the default website has a messageboard named "([^"]*)"$/ do |messageboard|
  @site = Site.find_by_cached_domain(THREDDED[:default_domain])
  @site.messageboards << Factory(:messageboard, :name => messageboard, :title => messageboard)
  @site.save
end

Given /^the default website has two messageboards named "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  Then %{the default website has a messageboard named "#{messageboard1}"}
  And %{the default website has a messageboard named "#{messageboard2}"}
end

Then /^I should see the messageboard called "([^"]*)"$/ do |messageboard|
  page.should have_selector(".messageboard header h2", :text => messageboard)
end

Then /^I should see messageboards "([^"]*)" and "([^"]*)"$/ do |messageboard1, messageboard2|
  Then %{I should see the messageboard called "#{messageboard1}"}
  And  %{I should see the messageboard called "#{messageboard2}"}
end

Given /^a subdomain site exists called "([^"]*)"$/ do |subdomain|
  @site = Site.where("cached_domain = ? OR  subdomain = ?", subdomain, subdomain)
  Factory(:site, :subdomain => slug) if @site.nil?
end

Given /^"([^"]*)" has two messageboards named "([^"]*)" and "([^"]*)"$/ do |subdomain, messageboard1, messageboard2|
  @site = Site.where("cached_domain = ? OR  subdomain = ?", subdomain, subdomain)
  @site.messageboards << Factory(:messageboard, :name => messageboard1, :title => messageboard1)
  @site.messageboards << Factory(:messageboard, :name => messageboard2, :title => messageboard2)
  @site.save
end

Given /^a custom domain site exists called "([^"]*)"$/ do |domain|
  Factory(:site, :cname_alias => domain)
end

Then /^I should see the login form$/ do
  page.should have_selector('form#user_new')
end

Then /^I should not see the login form$/ do
  page.should_not have_selector('form#user_new')
end
