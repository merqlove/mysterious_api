module WardenHelper
  extend ActiveSupport::Concern

  def unauthenticated
    render json: { error: 'Bad credentials' }, status: 401
  end

  private

  def signed_in?
    !current_user.nil?
  end

  def current_user
    warden&.user
  end

  def warden
    request.env['warden']
  end

  def authenticate!
    warden&.authenticate!
  end
end
