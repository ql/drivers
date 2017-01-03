class Driver
  include Mongoid::Document

  field :name, type: String
  has_one :token, dependent: :delete, as: :tokenized, validate: false

  has_one :task, validate: false

  after_create do
    self.token = Token.create(role: 'driver')
    save
  end

  def as_json(args)
    {name: name, id: _id.to_s}
  end
end
