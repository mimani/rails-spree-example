class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)

    if resource_or_scope.has_spree_role?("catalog")
      '/admin/products'
    else
      '/admin/orders'
    end
  end

  def after_sign_out_path_for(resource_or_scope)
  	'/admin/login'
  end
end
