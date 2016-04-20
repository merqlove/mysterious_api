class WelcomeController < ActionController::API
  def index
    render body: 'Welcome to the roots!'
  end
end
