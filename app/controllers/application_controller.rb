class ApplicationController < ActionController::API
  include SerializationConcern
  include AuthorizationConcern
end
