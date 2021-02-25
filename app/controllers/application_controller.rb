class ApplicationController < ActionController::Base
  include Pundit
  include Organizational


  protect_from_forgery
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from Organizational::UnknownOrganization, with: :not_authorized

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :all_casa_admin
      new_all_casa_admin_session_path
    else
      root_path
    end
  end

  private

  def not_authorized
    flash[:notice] = t("default", scope: "pundit")
    redirect_to(request.referrer || root_url)
  end
end
