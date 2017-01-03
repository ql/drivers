class Driver
  include Mongoid::Document

  field :name, type: String

  has_one :token
  belongs_to :task
end
