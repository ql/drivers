class Token
  include Mongoid::Document

  belongs_to :tokenized, polymorphic: true

  field :token, type: String
  field :role, type: String

  before_save do
    self.token = SecureRandom.urlsafe_base64
  end
end
