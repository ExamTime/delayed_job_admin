class DummyModel < ActiveRecord::Base
  attr_accessible :name
  def method_to_queue(input)
    Rails.logger.info "Running method: #{input}"
  end
end
