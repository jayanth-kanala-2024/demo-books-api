module SerializationConcern
  extend ActiveSupport::Concern

  included do
    private

    def serialize(resource, serializer)
      serializer.new(resource).serialized_json
    end
  end
end
