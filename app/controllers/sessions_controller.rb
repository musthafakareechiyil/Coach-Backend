class SessionsController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user && user.password == params[:password]
      render json: {
        user: user,
        token: "dummy-token",
        message: "logged in successfully"
      },
      status: :ok
    else
      render json: { erorr: "Invalid Credentials" }, status: :unauthorized
    end
  end
end
