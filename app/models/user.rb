class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable
  belongs_to :role

  def role?(needed_role)
    role.name == needed_role.to_s
  end

  def admin?
    role? :admin
  end

  def worker?
    role? :worker
  end
end
