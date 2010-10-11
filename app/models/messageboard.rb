class Messageboard
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :theme, :type => String  
  field :topic_count, :type => Integer
  field :security, :type => Symbol
  SECURED_WITH = [:public, :private, :logged_in]

  validates_inclusion_of :security, :in => SECURED_WITH
  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w\-]+$/, :on => :create, :message => "should be letters, nums, dash, underscore only."
  validates_uniqueness_of :name, :message => "must be a unique board name. Try again."
  validates_length_of     :name, :within => 1..16, :message => "should be between 1 and 16 characters" 

  embeds_many :topics

  def to_param
    "#{name.downcase}"
  end

end
