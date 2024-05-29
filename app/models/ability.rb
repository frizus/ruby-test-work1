class Ability
  include CanCan::Ability



  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    can :access, :rails_admin
    can :read, :dashboard

    if user.admin?
      can :manage, [User, Role]
      can [
            :index,
            :export,
            :new,
            :bulk_delete,
            :show,
            :edit,
            :delete,
            :show_in_app,

            :approval_admin_delete,
          ], Approval
    elsif user.worker?
      cannot :manage, Approval
      can :index, Approval, created_by_id: user.id
      can [
            :approval_worker_delete,
            :approval_worker_edit,
            :approval_worker_new,
            :approval_worker_show
          ], Approval
      # cannot [
      #          #:index,
      #          :export,
      #          :new,
      #          :bulk_delete,
      #          :show,
      #
      #          :edit,
      #          :delete,
      #          :show_in_app,
      #        ], Approval
      # https://github.com/railsadminteam/rails_admin/wiki/CanCanCan#railsadmin-verbs

    end
  end
end
