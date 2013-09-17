class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= NullUser.new
  end
end
