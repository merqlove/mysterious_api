module Api
  module V1
    class ApplicationController < ::Api::ApplicationController
      before_action :authenticate!
      after_action :verify_authorized

      include PaginationDict
    end
  end
end
