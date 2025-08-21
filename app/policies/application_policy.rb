class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user     
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Scope object for policy_scope
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user   # current_user
      @scope = scope # usually an ActiveRecord::Relation
    end

    def resolve
      scope.all
    end
  end
end
