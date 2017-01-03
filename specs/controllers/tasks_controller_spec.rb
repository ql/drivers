require File.join(File.dirname(__FILE__), '..', 'spec_helper')
describe "Tasks" do
  include Rack::Test::Methods
  def app
    Drivers
  end

  subject { last_response }
  let(:task_attributes) { {pickup: {lat: 55.703199, lon: 37.504350}, destination: {lat: 55.825532, lon: 37.696611}} }
  let(:manager) { Manager.create!(name: 'Vasya') }
  let(:driver) { Driver.create!(name: 'Petya') }

  describe "POST /tasks" do
    context "role manager" do
      before(:each) do
        header 'Access-Token', manager.token.token
        post("/tasks", task_attributes)
      end
      it { should be_successful }
    end

    context "role driver" do
      before(:each) do
        header 'Access-Token', driver.token.token
        post("/tasks", task_attributes)
      end
      it { should be_unauthorized }
    end

    context "unathenticated user" do
      before(:each) { post "/tasks" }
      it { should be_unauthorized }
    end
  end
end
