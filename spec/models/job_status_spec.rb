require 'spec_helper'

describe JobStatus do
  it 'should be defined' do
    expect(JobStatus).not_to be_nil
  end

  [:job_id, :job_status, :to_json].each do |method|
    it "should respond to the method '#{method}'" do
      expect(JobStatus.new(99)).to respond_to method
    end
  end

  describe 'instantiation' do
    describe 'two parameters supplied' do
      before :each do
        @instance = JobStatus.new(99, Delayed::Job::FAILING)
      end

      it 'should successfully create a new instance' do
        expect(@instance).not_to be_nil
        expect(@instance).to be_a JobStatus
      end

      it 'should set the job_id appropriately' do
        expect(@instance.job_id).to eq(99)
      end

      it 'should set the job_status appropriately' do
        expect(@instance.job_status).to eq(Delayed::Job::FAILING)
      end
    end

    describe 'single parameter supplied' do
      before :each do
        @instance = JobStatus.new(99)
      end

      it 'should successfully create a new instance' do
        expect(@instance).not_to be_nil
        expect(@instance).to be_a JobStatus
      end

      it 'should set the job_id appropriately' do
        expect(@instance.job_id).to eq(99)
      end

      it 'should set the job_status to a default value of PENDING' do
        expect(@instance.job_status).to eq(Delayed::Job::PENDING)
      end
    end

    describe 'no parameters supplied' do
      it 'should raise an error' do
        expect{ JobStatus.new }.to raise_error ArgumentError
      end
    end
  end

  describe 'instance method' do

    describe '#to_json' do
      before :each do
        @job_status = JobStatus.new(98, Delayed::Job::PROCESSING)
      end

      it 'should return a string' do
        expect(@job_status.to_json).to be_a String
      end

      { "job_id" => "\"job_id\":98", "job_status" => "\"job_status\":\"processing\"" }.each do |key,value|
        it "should encode the #{key} model property in the json string" do
          expect(@job_status.to_json).to include value
        end
      end

    end
  end
end
