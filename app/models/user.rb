class User < ActiveRecord::Base
  require 'gravtastic'
  include Gravtastic
  include ActiveModel::Dirty

  gravtastic :email, size: 142

  has_many :identities

  attr_accessible :email,
    :name,
    :password,
    :password_confirmation,
    :post_filter,
    :provider,
    :remember_me,
    :time_zone,
    :uid

  devise :database_authenticatable,
    :recoverable,
    :registerable,
    :rememberable,
    :token_authenticatable,
    :trackable

  validates :name,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[a-zA-Z0-9]+\z/,
      message: 'only letters or numbers allowed'
    }

  validates :email,
    presence: true,
    uniqueness: true,
    length: {
      minimum: 3,
      maximum: 254
    },
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
      message: 'invalid email address'
    }

  def self.from_omniauth(auth_hash)
    where(email: auth_hash['info']['email']).first ||
      create_from_omniauth(auth_hash)
  end

  def to_param
    self.name
  end

  private

  def self.create_from_omniauth(auth_hash)
    create!(email: auth_hash['info']['email'], name: auth_hash['info']['nickname'])
  end
end
