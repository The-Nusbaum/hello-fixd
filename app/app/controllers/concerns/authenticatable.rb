module Authenticatable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  attr_reader :current_user
  attr_reader :current_key

    def authenticate_with_key!
    @current_user = authenticate_or_request_with_http_token &method(:authenticator)
  end

    def authenticate_with_key
    @current_user = authenticate_with_http_token &method(:authenticator)
  end

  private

  attr_writer :current_user
  attr_writer :current_key

  def authenticator(token, options)
    @current_key = ApiKey.authenticate_by_token token 

    current_key&.user
  end
end