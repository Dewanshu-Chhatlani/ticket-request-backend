class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:sign_up, :login]

  def sign_up
    @user = User.create(user_params)

    if @user.errors.empty?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}, status: :created
    else
      render json: {error: @user.errors.full_messages.to_sentence}, status: :bad_request
    end
  end

  def login
    @user = User.find_by(email: user_params[:email])

    if @user && @user.authenticate(user_params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: 'Invalid email and/or password!'}, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
