class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ErrorHandler
  include WardenHelper
  include PunditHelper
  include PolicyHelper
end
