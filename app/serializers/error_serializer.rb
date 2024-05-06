class ErrorSerializer
  include FastJsonapi::ObjectSerializer

  def initialize(errors)
    @errors = errors
  end

  def serializable_hash
    {
      errors: @errors.map { |error| { detail: error } }
    }
  end
end
