class ApiKeysController < ApplicationController
  include Authenticatable
  prepend_before_action :authenticate_with_key!, only: %i[index destroy]
 
  def index
    render json: current_user.api_keys 
  end
 
  def create
    authenticate_with_http_basic do |email, password| 
      user = User.find_by email: email 
 
      if user&.authenticate(password) 
        key = user.api_keys.create! token: SecureRandom.hex 
 
        render json: key, status: :created and return 
      end 
    end
 
    render status: :unauthorized
  end
 
  def destroy
    key = current_user.api_keys.find(params[:id]) 
    key&.destroy 
  end
end