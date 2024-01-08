class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    render json: {error: 'Unable to authenticate!'}, status: :unauthorized if logged_in_user.blank?
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find(user_id)
    end
  end

  def encode_token(payload, exp = 12.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key)
  end

  def decoded_token
    auth_header = request.headers['Authorization']

    if auth_header
      token = auth_header.split(' ')[1]
      JWT.decode(token, Rails.application.secrets.secret_key)
    end
  end
end
