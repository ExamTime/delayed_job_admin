class Delayed::Job
  def apply_handlers
    DelayedJobAdmin.destroy_handlers.each do |clazz|
      handler = clazz.new(self)
      handler.handle
    end
  end
end
