class Reactor::Subscriber < ActiveRecord::Base
  attr_accessible :event
  attr_accessor :message

  def event=(event)
    write_attribute :event, event.to_s
  end

  def fire(data)
    self.message = Reactor::Event.new(data)
    instance_exec &self.class.on_fire
    self
  end

  def delay_amount
    self.class.delay_amount
  end

  class << self
    def on_fire(&block)
      if block
        @fire_block = block
      end
      @fire_block
    end

    def fire(subscriber_id, data)
      Reactor::Subscriber.find(subscriber_id).fire data
    end

    def subscribes_to(name = nil, delay: nil)
      @delay_amount = delay
      #subscribers << name
      #TODO: REMEMBER SUBSCRIBERS so we can define them in code as well as with a row in the DB
    end

    def delay_amount
      @delay_amount
    end

  end
end