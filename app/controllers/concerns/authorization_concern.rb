module AuthorizationConcern
  extend ActiveSupport::Concern

  # included do
  #   before_action :authorize_user
  # end

  def authorize_user(role)
    set_user_data()
    # Authorization logic

    case role
    when 'admin'
      authorize_admin_access(role)
    when 'regular'
      authorize_user_access(role)
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def authorize_user_access(role)
    puts "AUTHORIZE USER CHECK: #{@role_from_jwt}, #{role}"
    unless @role_from_jwt == role
      render json: ErrorSerializer.new({id: @user_id_from_jwt, error: 'Access forbidden' }).serialized_json, status: :forbidden
    end
  end

  def authorize_admin_access(role)
    puts "AUTHORIZE ADMIN CHECK: #{@role_from_jwt}, #{role}"
    # if require add additional checks along with role
    unless @role_from_jwt == role
      render json: ErrorSerializer.new({id: @user_id_from_jwt, error: 'Access forbidden' }).serialized_json, status: :forbidden
    end
  end

  private
  def set_user_data
    @role_from_jwt = request.env['role']
    @user_id_from_jwt = request.env['user_id']
  end

end
