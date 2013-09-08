require 'spec_helper'

describe JobStatus do
  it 'should be defined' do
    JobStatus.should_not be_nil
  end

  [:job_id, :job_status, :to_json].each do |method|
    it "should respond to the method '#{method}'" do
      JobStatus.new(99).should respond_to method
    end
  end

  describe 'instantiation' do
    describe 'two parameters supplied' do
      before :each do
        @instance = JobStatus.new(99, Delayed::Job::FAILING)
      end

      it 'should successfully create a new instance' do
        @instance.should_not be_nil
        @instance.should be_a JobStatus
      end

      it 'should set the job_id appropriately' do
        @instance.job_id.should == 99
      end

      it 'should set the job_status appropriately' do
        @instance.job_status.should == Delayed::Job::FAILING
      end
    end

    describe 'single parameter supplied' do
      before :each do
        @instance = JobStatus.new(99)
      end

      it 'should successfully create a new instance' do
        @instance.should_not be_nil
        @instance.should be_a JobStatus
      end

      it 'should set the job_id appropriately' do
        @instance.job_id.should == 99
      end

      it 'should set the job_status to a default value of PENDING' do
        @instance.job_status.should == Delayed::Job::PENDING
      end
    end

    describe 'no parameters supplied' do
      it 'should raise an error' do
        lambda{ JobStatus.new }.should raise_error ArgumentError
      end
    end
  end

  describe 'instance method' do

    describe '#to_json' do
      before :each do
        @job_status = JobStatus.new(98, Delayed::Job::PROCESSING)
      end

      it 'should return a string' do
        @job_status.to_json.should be_a String
      end

      { "job_id" => "\"job_id\":98", "job_status" => "\"job_status\":\"processing\"" }.each do |key,value|
        it "should encode the #{key} model property in the json string" do
          @job_status.to_json.should include value
        end
      end

    end
  end
end
