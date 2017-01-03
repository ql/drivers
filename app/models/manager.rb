class Manager
  include Mongoid::Document

  field :name, type: String
  has_one :token
end
