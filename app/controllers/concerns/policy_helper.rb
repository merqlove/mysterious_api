module PolicyHelper
  extend ActiveSupport::Concern

  private

  def authorize_api(*args)
    object, *params = args
    send(:authorize, policy_namespace(object), *params)
  end

  def policy_namespace(object)
    @arg = self.class.to_s.split("::").map!{ |x| x.underscore.to_sym}
    @arg[-1] = object
    @arg
  end
end
