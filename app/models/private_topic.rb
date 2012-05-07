class PrivateTopic < Topic
  has_many :private_users
  has_many :users, through: :private_users
  attr_accessible :user_id

  def user_id=( ids )
    if ids.size > 0
      self.users = User.where(id: ids.uniq)
    end
  end

  def add_user( user )
    user = User.find_by_name(user) if String == user.class
    users << user
  end
end
