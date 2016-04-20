module PunditHelper
  extend ActiveSupport::Concern

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized!
  end

  private

  def unauthorized!
    render json: { error: 'Authorization required' }, status: 403
  end
end
