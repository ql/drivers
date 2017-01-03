class Token
  include Mongoid::Document

  field :token, type: String
  field :role, type: String
  has_one :token
end
