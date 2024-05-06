class AuthController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    if !@user
      render json: { error: true, message: 'User does not exist' }, status: :unauthorized
    elsif @user && @user.authenticate(params[:password])
      token = JwtMiddleware.create_token(@user)
      JwtMiddleware.store_token_to_redis(@user.id, token)
      render json: get_success_response(token)
    else
      render json: { error: true, message: 'Invalid username or password' }, status: 401
    end
  end

  def signup
    @user = User.new(signup_params)
    unless params[:terms]
      @user.errors.add :terms, :too_plain, message: 'Accept the terms'
      return render json: { error: true, message: @user.errors }, status: :unprocessable_entity
    end

    if @user.save
      # create jwt token save in redis and pass to email to implement verification
      UserMailer.welcome_email(@user).deliver_later
      render json: @user, only: %i[id email], status: :created
    else
      render json: { error: true, message: @user.errors }, status: :unprocessable_entity
    end
  end

  def logout
    payload = request.env['jwt.payload']
    user_id = payload.first['user_id']
    token = payload.first['token']
    JwtMiddleware.delete_token_from_redis(user_id, token)
    render json: { error: false, message: 'Logout success' }
  end

  def email
    status = UserMailer.welcome_email(@user).deliver_later
    puts "EMAIL STATUS: #{status}"
    render json: {error: false, message: "hello"}
  end

  private

  def login_params
    params.fetch(:auth, {}).permit(:email, :password)
  end

  def signup_params
    params.fetch(:auth, {}).permit(:name, :email, :password, :confirm_password)
  end

  def get_success_response(token)
    {
      error: false,
      data: [
        {
          name: @user.name,
          user_id: @user.id,
          email: @user.email,
          token: token,
          isAuthenticated: true,
          role: @user.role
        }
      ]
    }
  end
end
