class DummyModel < ActiveRecord::Base
  attr_accessible :name, :delay_in_seconds
  after_initialize :default_delay_in_seconds

  def method_to_queue(input)
    Rails.logger.info "Running method call: #{input}"
    sleep(self.delay_in_seconds)
    raise StandardError "Method raised and error" if input == 'ERROR'
    Rails.logger.info "Completing method call: #{input}"
  end

  private

  def default_delay_in_seconds
    self.delay_in_seconds = 1 if self.delay_in_seconds.blank?
  end
end
