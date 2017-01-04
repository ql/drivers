class Manager
  include Mongoid::Document

  field :name, type: String
  has_one :token, dependent: :delete, as: :tokenized, validate: false

  after_create do
    self.token = Token.create(role: 'manager')
    save
  end

  def as_json(*args)
    {name: name, id: _id.to_s, token: token.token}
  end
end
