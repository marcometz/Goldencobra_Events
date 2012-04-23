module GoldencobraEvents
  class ApplicationController < ActionController::Base
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_dashboard_path, :alert => exception.message
    end
  end
end
