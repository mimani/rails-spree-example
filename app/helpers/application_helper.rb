module ApplicationHelper
  def isUserAdmin user
    Spree::Role.find_each do |admin|
      if user.try(:has_spree_role?, admin.name)
        return admin.name
      end
    end
    return "user"
  end
end
