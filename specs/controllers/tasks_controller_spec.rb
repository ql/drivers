require File.join(File.dirname(__FILE__), '..', 'spec_helper')
describe "Tasks" do
  include Rack::Test::Methods
  def app
    Drivers
  end

  subject { last_response }
  let(:task_attributes) { {pickup: [55.703199, 37.504350], destination: [55.825532, 37.696611]} }
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

  describe "GET /tasks/available" do
    context "unathenticated user" do
      before(:each) { get "/tasks/available" }
      it { should be_unauthorized }
    end

    context "role driver" do
      before(:each) do
        @task1 = Task.create(pickup: [55.745827, 37.568551], destination: [0,0])
        @task2 = Task.create(pickup: [55.757832, 37.562371], destination: [0,0])
        @task3 = Task.create(pickup: [55.710566, 37.909814], destination: [0,0]) #far away
        header 'Access-Token', driver.token.token
        get("/tasks/available", {location: [55.745827, 37.568551]})
      end
      it { subject.body.should == [@task1, @task2].to_json }
    end
  end
end
