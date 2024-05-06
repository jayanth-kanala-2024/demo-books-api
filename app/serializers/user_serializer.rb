class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email, :role
end
