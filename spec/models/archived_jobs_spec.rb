require 'spec_helper'

class DummyGenerator
  def get_datetime
    DateTime.new(2013,8,26)
  end
end

ATTRIBUTE_LIST = [ :id,
                   :priority,
                   :attempts,
                   :handler,
                   :last_error,
                   :locked_at,
                   :failed_at,
                   :locked_by,
                   :queue,
                   :created_at,
                   :updated_at,
                   :archived_at,
                   :archive_note ]

describe DelayedJobAdmin::ArchivedJob do

  before :all do
    queued_model = DummyModel.create(name: 'Model in queue')
    @job = queued_model.delay.method_to_queue('in queue')
    @attributes = { job: @job,
                    archived_at: DateTime.now,
                    archive_note: 'Test archival' }
  end

  before :each do
    @archived_job = DelayedJobAdmin::ArchivedJob.new(@attributes)
  end

  describe 'an instance' do
    ATTRIBUTE_LIST.each do |attr|
      it "should have an attribute named '#{attr}'" do
        @archived_job.should respond_to attr
      end
    end
  end

  describe 'instantiation' do

    it 'should be invalid if archive_note is not supplied' do
      @archived_job.archive_note = nil
      @archived_job.should_not be_valid
    end

    it 'should be invalid if archived_at is not supplied' do
      @archived_job.archived_at = nil
      @archived_job.should_not be_valid
    end

    it 'should set archived_at to the time passed, if supplied' do
      test_time = Time.now - 1.days
      @archived_job.archived_at = test_time
      @archived_job.should be_valid
      @archived_job.archived_at.should == test_time
    end

    it 'should default archived_at to the datetime mandated by the datetime_generator' do
      @dummy_generator = DummyGenerator.new
      new_instance = DelayedJobAdmin::ArchivedJob.new(@attributes.merge({ datetime_generator: @dummy_generator, archived_at: nil }))
      new_instance.archived_at.should_not be_nil
      new_instance.archived_at.should == @dummy_generator.get_datetime
    end
  end
end
