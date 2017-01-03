class Task
  include Mongoid::Document

  field :pickup, type: Hash
  field :destination, type: Hash
  field :status, type: String

  has_one :driver

  state_machine :status, :initial => :new do
    event :assign do
      transition :new => :assigned
    end

    event :finish do
      transition :assigned => :done
    end
  end

  def self.around(location)
    raise NotImplemented
  end

  def assign_to(driver)
    update_attribute(driver: driver)
    assign!
  end

  def finish
    finish!
  end
end
