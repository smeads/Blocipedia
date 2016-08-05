class WikiPolicy < ApplicationPolicy

  class Scope < Scope
    attr_reader :user, :scope

    def initializer(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if @user.admin?
        wikis = scope.all
      elsif @user.premium?
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user_id == @user || wiki.users.include?(@user)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.users.include?(@user)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end
end
