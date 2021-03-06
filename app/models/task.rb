class Task
  include Mongoid::Document
  SEARCH_RADIUS = 3000

  field :pickup, type: Hash
  field :destination, type: Hash
  field :status, type: String
  index({ pickup: "2dsphere" })

  has_one :driver

  validates :pickup, presence: true
  validates :destination, presence: true

  state_machine :status, :initial => :new do
    event :assign do
      transition :new => :assigned
    end

    event :finalize do
      transition :assigned => :done
    end
  end

  def self.around(location)
    mongo_loc = location.reverse.map(&:to_f)
    where({pickup: { "$nearSphere": {"$geometry": { type: "Point", coordinates: mongo_loc}, "$maxDistance": SEARCH_RADIUS }}})
  end

  def assign_to(driver)
    update_attribute(driver: driver)
    assign!
  end

  def finish
    finish!
  end

  def pickup
    self[:pickup].try(:fetch, "coordinates").try(:reverse)
  end

  def pickup=(arr)
    self[:pickup] = {type: "Point", coordinates: arr.reverse.map(&:to_f)}.stringify_keys
  end

  def destination
    self[:destination].try(:fetch, "coordinates", []).try(:reverse)
  end

  def destination=(arr)
    self[:destination] = {type: "Point", coordinates: arr.reverse.map(&:to_f) }.stringify_keys
  end

  def as_json(*args)
    {pickup: pickup, status: status, destination: destination, id: _id.to_s}
  end
end
