module TokenAuth
  extend ActiveSupport::Concern

  included do
    before_create :generate_authentication_token
  end

  def generate_authentication_token!
    token = generate_authentication_token
    self.save
    token
  end

  private

  def generate_authentication_token
    token                     = SecureRandom.urlsafe_base64(nil, false)
    self.authentication_token = ::BCrypt::Password.create(token)
    token
  end
end
