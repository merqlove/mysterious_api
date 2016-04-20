module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :error
    rescue_from Exception, with: :error
    rescue_from ActionController::RoutingError, with: :error
  end

  def raise_not_found
    fail ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  private

  def error(e)
    return if performed?
    fetch_exception(e)
    error_from_response(e)
  end

  def error_from_response(e)
    self.response_body = nil
    message = Rails.env.development? || Rails.env.test? ? "#{e&.class.name} : #{e&.message}" : e&.message
    error_info = {
        error: @rescue_response,
        message: message
    }
    unless Rails.env.production?
      Rails.logger.error e
      e&.backtrace[0, 10].each { |l| Rails.logger.error l }
    end
    error_info[:trace] = e&.backtrace[0, 10] if Rails.env.development?
    render json: error_info.to_json, status: @status_code
  end

  def fetch_exception(e)
    @status_code = ActionDispatch::ExceptionWrapper.new(request.env, e).status_code
    @rescue_response = ActionDispatch::ExceptionWrapper.rescue_responses[e&.class.name]
  end
end
