class Track
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: Mongoid::Boolean
end
